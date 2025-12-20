#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/NoFolder.h>
#include <llvm/IR/IntrinsicInst.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/InlineAsm.h>
#include <llvm/Pass.h>
#include <llvm/IR/PassManager.h>
#include <llvm/Passes/PassBuilder.h>
#include <llvm/Passes/PassPlugin.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Demangle/Demangle.h>
#include <iostream>
#include <random>
#include "Distribution-Generation/GenerateDistribution.hpp"
#include "Utils/Utils.hpp"

using namespace llvm;

constexpr const char* PASS_NAME = "POP";

namespace
{
    struct ProbabilisticOpaquePredicatesPass : public PassInfoMixin<ProbabilisticOpaquePredicatesPass>
    {
        PreservedAnalyses run(Module& M, ModuleAnalysisManager& AM)
        {
            LLVMContext& LLVMCtx = M.getContext();
            IRBuilder<> IRB(LLVMCtx);

            std::random_device Dev;
            std::mt19937 Rng(Dev());

            for (Function& F : M)
            {
                // Check if our function is defined and not just declared
                if (F.isDeclaration()) continue;

                // Check if function has required annotation
                if (!Utils::HasAnnotation(&F, PASS_NAME)) continue;

                errs() << "Running on " << demangle(F.getName()) << "\n";

                // Insert at random place in function
                // We have to guarantee that this random place is after all PHI instructions
                std::vector<BasicBlock::iterator> ValidInsertionPts;

                for (BasicBlock& BB : F)
                {
                    auto It = BB.getFirstInsertionPt();

                    // BB is either empty or malformed
                    if (It == BB.end()) continue;

                    for (; It != BB.end(); It++)
                        ValidInsertionPts.push_back(It);
                }

                const auto RandomInsertionIdx = std::uniform_int_distribution(static_cast<size_t>(0), 
                    ValidInsertionPts.size() - 1)(Rng);
                const auto RandomInsertionPt = ValidInsertionPts[RandomInsertionIdx];
                auto RandomBasicBlock = (*RandomInsertionPt).getParent();

                IRB.SetInsertPoint(RandomInsertionPt);
               
                // TODO: Multiple Methods for getting randomness

                // Get parameter to create a symbolic variable for the solver
                if (F.arg_empty())
                    continue;

                Value* Parameter = &*F.arg_begin();

                // Tell LLVM that we might modify the value in a way it can't predict
                // so that it doesn't perform constant folding
                Type* Ty = Parameter->getType();
                // "r" means use a register, "0" means the output is the same as input 0
                InlineAsm* IA = InlineAsm::get(FunctionType::get(Ty, {Ty}, false), "", "=r, ~{memory},~{dirflag},~{fpsr},~{flags}", true);
                Value* VolatileParameter = IRB.CreateCall(IA, {Parameter});

                // Cast the variable to a double
                const auto DoubleCallParameter = Utils::CastIRValueToDouble(VolatileParameter, IRB);

                // Make variable lie in [0;1]
                // We do this this way because LLVM *somehow* messes up if we perform a division with IRB.CreateFDiv in the IR
                constexpr double RecipMax = 1.0 / std::numeric_limits<double>::max();
                Value* RecipMaxConstant = ConstantFP::get(IRB.getDoubleTy(), RecipMax);

                const auto SmallCallParameter = IRB.CreateFMul(DoubleCallParameter, RecipMaxConstant);

                // Generate random inverse CDF
                const auto [SamplerFn, Bernsteinpolynomial, DomainStart, DomainEnd] = Distribution::InsertRandomBernsteinNewtonRaphson(M, Rng);

                // i64 x = sampler(u)
                const auto SampleRet = IRB.CreateCall(SamplerFn, { SmallCallParameter });

                errs() << "Start: " << DomainStart << " End: " << DomainEnd << "\n";

                // Choose whether the predicate should always be true or false
                const bool PredicateType = std::uniform_int_distribution(0, 1)(Rng); // always false || always true

                // Compute needed threshold for Bernsteinpolynomial
                double Threshold = Bernsteinpolynomial.GetHorizontalShift() + (0.5 / Bernsteinpolynomial.GetHorizontalStretch());

                const std::vector<double> DerivativeCoefficients = Bernsteinpolynomial.GetDerivativeCoefficients();

                for (int i = 0; i < 16; i++)
                {
                    double CurrentY = Bernsteinpolynomial.EvaluateAt(Threshold);
                    double CurrentSlope = Bernsteinpolynomial.EvaluateDerivativeAt(Threshold);

                    // f(x) = B(x) - Target
                    double OffsetY = CurrentY - 0.9;
                    
                    // Newton Step: x = x - f(x) / f'(x)
                    Threshold -= OffsetY / CurrentSlope;
                }
                
                errs() << "Threshold: " << Threshold << "\n";
                errs() << "PredicateType: " << PredicateType << "\n";

                // Create predicate
                Value* CmpResult;
                if (PredicateType == true) // always true predicate
                {
                    // if x < Threshold...
                    CmpResult = IRB.CreateFCmpOLT(SampleRet,
                        ConstantFP::get(IRB.getDoubleTy(), Threshold));
                }
                else // always false predicate
                {
                    // if x > Threshold...
                    CmpResult = IRB.CreateFCmpOGT(SampleRet,
                        ConstantFP::get(IRB.getDoubleTy(), Threshold));
                }

                // Create new BasicBlocks for branches
                const auto TrueBB = SampleRet->getParent()->splitBasicBlock(IRB.GetInsertPoint(), "always_hit");
                const auto FalseBB = BasicBlock::Create(LLVMCtx, "never_hit", &F);

                // Replace terminator of BasicBlock (unconditional br added by splitBasicBlock) with ours
                RandomBasicBlock->getTerminator()->eraseFromParent();

                IRB.SetInsertPoint(TrueBB->getFirstInsertionPt());
                Utils::PrintfIR(M, IRB, "TrueBB says hi\n");

                IRB.SetInsertPoint(RandomBasicBlock);
                if (PredicateType == true)
                    IRB.CreateCondBr(CmpResult, TrueBB, FalseBB);
                else
                    IRB.CreateCondBr(CmpResult, FalseBB, TrueBB);

                IRB.SetInsertPoint(FalseBB);
                Utils::PrintfIR(M, IRB, "FalseBB says hi\n");
                // IRB.CreateUnreachable(); // TODO
                // Function *Trap = Intrinsic::getDeclaration(&M, Intrinsic::trap);
                // IRB.CreateCall(Trap);
                // IRB.CreateBr(FalseBB);
                if (F.getReturnType()->isVoidTy()) 
                    IRB.CreateRetVoid();
                else 
                    IRB.CreateRet(Constant::getNullValue(F.getReturnType()));
            }

            return PreservedAnalyses::all();
        }
    };
}

// New PassManager registration
extern "C" LLVM_ATTRIBUTE_WEAK::llvm::PassPluginLibraryInfo
    llvmGetPassPluginInfo()
{
    return 
    { 
        LLVM_PLUGIN_API_VERSION, "ProbabilisticOpaquePredicates", "v0.1", 
        [](PassBuilder& PB)
        {
            // For opt -passes=PASS_NAME
            PB.registerPipelineParsingCallback([](StringRef Name, ModulePassManager& MPM, ...)
            {
                if (Name == PASS_NAME)
                {
                    MPM.addPass(ProbabilisticOpaquePredicatesPass());
                    return true;
                }
                return false;
            });

            // For clang -fpass-plugin
            // This registers the pass to run at the start of the pipeline.
            PB.registerPipelineStartEPCallback([](ModulePassManager &MPM, OptimizationLevel Level) 
            {
                MPM.addPass(ProbabilisticOpaquePredicatesPass());
            });
        }
    };
}