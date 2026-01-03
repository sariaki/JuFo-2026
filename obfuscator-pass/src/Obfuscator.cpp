#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/NoFolder.h>
#include <llvm/IR/IntrinsicInst.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/InlineAsm.h>
#include <llvm/IR/DataLayout.h>
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
#include "Parameters.hpp"

using namespace llvm;

cl::OptionCategory PassCategory("Probabilistic Opaque Predicates (POP) Pass Options");

// TODO: Add limits and checks for parameters

// Insertion probability
constexpr const char* PASS_NAME = "POP";
cl::opt<unsigned int> POPInsertProbability(
    "pop-probability",
    cl::desc("Probability of applying the obfuscation (0-100)"), 
    cl::init(50),
    cl::cat(PassCategory)
);

// Predicate probability
// TODO: Make this fluctuate to throw off heuristics
cl::opt<unsigned int> POPPredicateProbability(
    "pop-predicate-probability",
    cl::desc("Probability that the opaque predicate evaluates to true (0-100)"),
    cl::init(98),
    cl::cat(PassCategory)
);

// Number of obfuscation runs per function
cl::opt<unsigned int> POPRunsPerFunction(
    "pop-runs-per-function",
    cl::desc("Number of obfuscation runs per function"),
    cl::init(1),
    cl::cat(PassCategory)
);

// Minimum and maximum degrees of bernstein polynomials
cl::opt<unsigned int> POPMinDegree(
    "pop-min-degree",
    cl::desc("Minimum degree of the bernstein polynomials used"),
    cl::init(3),
    cl::cat(PassCategory)
);

cl::opt<unsigned int> POPMaxDegree(
    "pop-max-degree",
    cl::desc("Maximum degree of the bernstein polynomials used"),
    cl::init(3),
    cl::cat(PassCategory)
);

// Iteration limit for Newton-Raphson method
constexpr unsigned int MIN_ITERATIONS = 7;
cl::opt<unsigned int> POPNewtonRaphsonIterations(
    "pop-iterations",
    cl::desc("Number of iterations for the Newton-Raphson method (minimum: 7)"),
    cl::init(12),
    cl::cat(PassCategory)
);

namespace
{
    struct ProbabilisticOpaquePredicatesPass : public PassInfoMixin<ProbabilisticOpaquePredicatesPass>
    {
        // StringMap<bool> FunctionsObfuscated;
        
        PreservedAnalyses run(Module& M, ModuleAnalysisManager& AM)
        {
            LLVMContext& LLVMCtx = M.getContext();
            IRBuilder<> IRB(LLVMCtx);

            std::random_device Dev;
            std::mt19937 Rng(Dev());

            const std::string AttrName = "pop-obfuscated";

            // make_early_inc_range allows safe modification of the function list,
            // needed when we add parameters to functions
            auto& FunctionsToProcess = M.getFunctionList();
            auto It = FunctionsToProcess.begin();
            while (It != FunctionsToProcess.end())
            {
                Function* Fn = &(*It);
                ++It;

                // Check if our function is defined and not just declared
                if (Fn->isDeclaration()) continue;

                // Skip obfuscated functions
                // if (FunctionsObfuscated.find(Fn->getName()) != FunctionsObfuscated.end()) continue;
                if (Fn->hasFnAttribute(AttrName)) continue;

                // Skip if function was inserted by us
                if (Fn->getName().contains("sample_bernstein_")) continue;

                // Skip intrinsics
                if (Fn->isIntrinsic()) continue;

                // Skip COMDAT functions (C++ Templates, Inline functions)
                // The linker merges these across files based on name/signature.
                // if (Fn->hasComdat()) continue;
                
                // Skip functions with their Address taken
                // If the address is taken, it might be called via a function pointer/vtable 
                // if (F.hasAddressTaken()) continue;

                // Check if function uses setjmp
                if (Fn->hasFnAttribute(Attribute::ReturnsTwice)) continue;

                // errs() << "Running on " << demangle(Fn.getName()) << "\n";
               
                // TODO: Multiple Methods for getting randomness

                // Get >=64 bit parameter derived from external fn to create a symbolic variable for the solver
                const DataLayout &DL = Fn->getParent()->getDataLayout();
                Value* Parameter = nullptr;

                // Find all callers of F through bitcasts/aliases
                SmallVector<CallBase*, 8> CallSites;
                for (User *U : Fn->users())
                {
                    // A user might be a CallInst or a BitCast of the function
                    Value *StrippedU = U;
                    if (auto *CB = dyn_cast<CallBase>(StrippedU))
                        CallSites.push_back(CB);
                    else 
                    {
                        // If the user is a bitcast, look at the users of the bitcast
                        for (User *UU : U->users()) 
                        {
                            if (auto *CB = dyn_cast<CallBase>(UU))
                                CallSites.push_back(CB);
                        }
                    }
                }

                // Analyze arguments
                for (CallBase *CB : CallSites)
                {
                    for (unsigned i = 0; i < CB->arg_size(); i++)
                    {
                        if (i >= Fn->arg_size()) break; // Varargs or mismatch

                        Value *Arg = CB->getArgOperand(i);

                        // Bit-width check
                        // if (DL.getTypeSizeInBits(Arg->getType()) == 64) // TODO: >= 64
                        {
                            SmallPtrSet<Value*, 32> Visited;
                            if (Utils::IsDerivedFromExternalFn(Arg, Visited, 0))
                            {
                                Parameter = Fn->getArg(i);
                                // errs() << "Match found: Function " << F.getName() 
                                //     << " has external 64-bit arg at index " << i << "\n";
                                break;
                            }
                        }
                    }
                }

                // Edge case for functions without callsites (e.g., main)
                if (CallSites.empty())
                {
                    for (Argument &Arg : Fn->args())
                    {
                        // Check if the argument is at least 64 bits wide
                        // if (DL.getTypeSizeInBits(Arg.getType()) >= 64)
                        {
                            Parameter = &Arg;
                            // errs() << "Match found: Function " << F.getName() 
                            //         << " has external 64-bit arg"<< "\n";
                            break;
                        }
                    }
                }

                if (!Parameter)
                {
                    // Add a dummy parameter to the function and make all callsites pass an external-derived value
                    // errs() << "Function " << demangle(F.getName()) 
                    //        << " has no (external-derived) argument (greater than 64 bits). Adding one.\n";

                    // Create a new Function with an extra argument
                    // TODO: and make all callsites pass an external-derived value
                    // Fn = Utils::AddLLVMFnArgument(&LLVMCtx, Fn, IRB.getInt64Ty(), "pop_external_param", ConstantInt::get(IRB.getInt64Ty(), 0));
                    // Parameter = Fn->getArg(Fn->arg_size() - 1); // Last argument is the new one
                    continue;
                }

                // Randomly decide if we should apply the obfuscation
                if (std::uniform_int_distribution(0, 99)(Rng) > POPInsertProbability.getValue())
                {
                    // If the function is annotated, we have to apply the obfuscation anyway
                    if (!Utils::HasAnnotation(Fn, PASS_NAME)) continue;
                }

                // for (unsigned int i = 0; i < POPRunsPerFunction.getValue(); i++)
                {
                    // Choose random insertion point
                    // We have to repoulate these lists
                    // since they currently might contain dangling pointers
                    std::vector<BasicBlock::iterator> ValidInsertionPts;
                    std::vector<BasicBlock*> BasicBlockCandidates; // Contenders for FakeBB

                    for (BasicBlock& BB : *Fn)
                    {
                        // It's forbidden to jump to the entry block or Exception Handling Pads
                        if (!(&BB == &Fn->getEntryBlock()) && !BB.isEHPad())
                            BasicBlockCandidates.push_back(&BB);

                        // We have to guarantee that this random place is after all PHI instructions
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

                    // Cast the parameter to a double
                    const auto DoubleCallParameter = Utils::CastIRValueToDouble(Parameter, IRB);

                    if (!DoubleCallParameter)
                    {
                        errs() << "Warning: Could not cast parameter in function " << demangle(Fn->getName()) << " - skipping.\n";
                        continue;
                    }

                    // Make parameter lie in [0;1]
                    // We do this this way because LLVM *somehow* messes up if we perform a division with IRB.CreateFDiv in the IR
                    constexpr double RecipMax = 1.0 / std::numeric_limits<double>::max();
                    Value* RecipMaxConstant = ConstantFP::get(IRB.getDoubleTy(), RecipMax);

                    const auto SmallCallParameter = IRB.CreateFMul(DoubleCallParameter, RecipMaxConstant);

                    // Generate random inverse CDF
                    const auto [SamplerFn, Bernsteinpolynomial, DomainStart, DomainEnd] = 
                        Distribution::InsertRandomBernsteinNewtonRaphson(M, *Fn, Rng);

                    // i64 x = sampler(u)
                    const auto SampleRet = IRB.CreateCall(SamplerFn, { SmallCallParameter });

                    // errs() << "Start: " << DomainStart << " End: " << DomainEnd << "\n";

                    // Choose whether the predicate should always be true or false
                    bool PredicateType = std::uniform_int_distribution(0, 1)(Rng); // always false || always true

                    // Compute needed threshold for Bernsteinpolynomial
                    double Threshold = Bernsteinpolynomial.GetHorizontalShift() + (0.5 / Bernsteinpolynomial.GetHorizontalStretch());

                    const std::vector<double> DerivativeCoefficients = Bernsteinpolynomial.GetDerivativeCoefficients();

                    for (int i = 0; i < 16; i++)
                    {
                        double CurrentY = Bernsteinpolynomial.EvaluateAt(Threshold);
                        double CurrentSlope = Bernsteinpolynomial.EvaluateDerivativeAt(Threshold);

                        // f(x) = B(x) - Target
                        double OffsetY = CurrentY - static_cast<double>(POPPredicateProbability.getValue()) / 100.0;
                        
                        // Newton Step: x = x - f(x) / f'(x)
                        Threshold -= OffsetY / CurrentSlope;

                        // Clamp to domain to avoid chaotic behavior
                        if (Threshold < DomainStart) Threshold = DomainStart;
                        if (Threshold > DomainEnd)   Threshold = DomainEnd;
                    }

                    // errs() << "Threshold: " << Threshold << "\n";
                    // errs() << "PredicateType: " << PredicateType << "\n";

                    // Create predicate
                    Value* CmpResult;
                    if (PredicateType) // always true predicate
                    {
                        // if x < Threshold...
                        CmpResult = IRB.CreateFCmpULT(SampleRet,
                            ConstantFP::get(IRB.getDoubleTy(), Threshold));
                    }
                    else // always false predicate
                    {
                        // if x > Threshold...
                        CmpResult = IRB.CreateFCmpUGT(SampleRet,
                            ConstantFP::get(IRB.getDoubleTy(), Threshold));
                    }

                    // Create new BasicBlocks for branches
                    BasicBlock* RealBB = SampleRet->getParent()->splitBasicBlock(IRB.GetInsertPoint(), "always_hit");
                    BasicBlock* FakeBB = nullptr;

                    // if (BasicBlockCandidates.empty())
                    // {
                    //     FakeBB = BasicBlock::Create(LLVMCtx, "never_hit", Fn);

                    //     IRB.SetInsertPoint(FakeBB);
                    //     // Utils::PrintfIR(M, IRB, "FakeBB says hi\n");

                    //     // TODO: Add junkcode
                    //     if (Fn->getReturnType()->isVoidTy()) 
                    //         IRB.CreateRetVoid();
                    //     else 
                    //         IRB.CreateRet(Constant::getNullValue(Fn->getReturnType()));
                    // }
                    // else
                    // {
                    //     const auto RandomBBIdx = std::uniform_int_distribution(static_cast<size_t>(0), 
                    //         BasicBlockCandidates.size() - 1)(Rng);
                    //     FakeBB = BasicBlockCandidates[RandomBBIdx];

                    //     // Fix PHI nodes in FakeBB
                    //     for (auto& PhiNode : FakeBB->phis())
                    //         PhiNode.addIncoming(UndefValue::get(PhiNode.getType()), RandomBasicBlock);
                    // }

                    // Replace terminator of BasicBlock (unconditional br added by splitBasicBlock) with ours
                    RandomBasicBlock->getTerminator()->eraseFromParent();

                    IRB.SetInsertPoint(RealBB->getFirstInsertionPt());
                    // Utils::PrintfIR(M, IRB, "RealBB says hi\n");

                    IRB.SetInsertPoint(RandomBasicBlock);
                    // if (PredicateType == true)
                    //     IRB.CreateCondBr(CmpResult, RealBB, FakeBB);
                    // else
                    //     IRB.CreateCondBr(CmpResult, FakeBB, RealBB);
                    if (PredicateType == true)
                        IRB.CreateCondBr(CmpResult, RealBB, RealBB);
                    else
                        IRB.CreateCondBr(CmpResult, RealBB, RealBB);
                }

                // Mark function as obfuscated so that the loop doesn't run infinitely
                // FunctionsObfuscated[Fn->getName()] = true;
                Fn->addFnAttr(AttrName);
            }

            return PreservedAnalyses::none();
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