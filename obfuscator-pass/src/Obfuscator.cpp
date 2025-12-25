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
    cl::init(99),
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
    cl::init(10),
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

                // Check if function was inserted by us
                if (F.getName().contains("sample_bernstein_")) continue;

                // Check if function uses setjmp
                if (F.hasFnAttribute(Attribute::ReturnsTwice)) continue;

                // Randomly decide if we should apply the obfuscation
                if (std::uniform_int_distribution(0, 99)(Rng) > POPInsertProbability)
                {
                    // If the function is annotated, we have to apply the obfuscation anyway
                    if (!Utils::HasAnnotation(&F, PASS_NAME)) continue;
                }

                // errs() << "Running on " << demangle(F.getName()) << "\n";

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

                // Get >=64 bit parameter derived from external fn to create a symbolic variable for the solver
                const DataLayout &DL = F.getParent()->getDataLayout();
                Value* Parameter = nullptr;

                // Find all callers of F through bitcasts/aliases
                SmallVector<CallBase*, 8> CallSites;
                for (User *U : F.users())
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
                        if (i >= F.arg_size()) break; // Varargs or mismatch

                        Value *Arg = CB->getArgOperand(i);

                        // Bit-width check
                        if (DL.getTypeSizeInBits(Arg->getType()) == 64) // TODO: >= 64
                        {
                            SmallPtrSet<Value*, 32> Visited;
                            if (Utils::IsDerivedFromExternalFn(Arg, Visited, 0))
                            {
                                Parameter = F.getArg(i);
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
                    for (Argument &Arg : F.args())
                    {
                        // Check if the argument is at least 64 bits wide
                        if (DL.getTypeSizeInBits(Arg.getType()) >= 64) {
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

                    // Function types in LLVM are immutable, so we have to create a new function with the new type
                    continue;
                }

                // // Tell LLVM that we might modify the value in a way it can't predict
                // // so that it doesn't perform constant folding
                // // Create a stack slot allocation for double
                // AllocaInst* Alloc = IRB.CreateAlloca(Parameter->getType());

                // // Volatile store parameter into it
                // IRB.CreateStore(Parameter, Alloc, true);

                // // Volatile Load it back
                // Value* VolatileParameter = IRB.CreateLoad(Parameter->getType(), Alloc, /*isVolatile=*/true);

                // Cast the variable to a double
                const auto DoubleCallParameter = Utils::CastIRValueToDouble(Parameter, IRB);

                if (!DoubleCallParameter)
                {
                    errs() << "Warning: Could not cast parameter in function " << demangle(F.getName()) << " - skipping.\n";
                    continue;
                }

                // Make variable lie in [0;1]
                // We do this this way because LLVM *somehow* messes up if we perform a division with IRB.CreateFDiv in the IR
                constexpr double RecipMax = 1.0 / std::numeric_limits<double>::max();
                Value* RecipMaxConstant = ConstantFP::get(IRB.getDoubleTy(), RecipMax);

                const auto SmallCallParameter = IRB.CreateFMul(DoubleCallParameter, RecipMaxConstant);

                // Generate random inverse CDF
                const auto [SamplerFn, Bernsteinpolynomial, DomainStart, DomainEnd] = 
                    Distribution::InsertRandomBernsteinNewtonRaphson(M, F, Rng);

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
                    double OffsetY = CurrentY - static_cast<double>(POPPredicateProbability) / 100.0;
                    
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
                // Utils::PrintfIR(M, IRB, "TrueBB says hi\n");

                IRB.SetInsertPoint(RandomBasicBlock);
                if (PredicateType == true)
                    IRB.CreateCondBr(CmpResult, TrueBB, FalseBB);
                else
                    IRB.CreateCondBr(CmpResult, FalseBB, TrueBB);

                IRB.SetInsertPoint(FalseBB);
                // Utils::PrintfIR(M, IRB, "FalseBB says hi\n");

                // TODO: Add junkcode
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