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
    "pop-lvl",
    cl::desc("Probability of applying the obfuscation (0-100)"), 
    cl::init(50),
    cl::cat(PassCategory)
);

// Predicate probability
// TODO: Make this fluctuate to throw off heuristics
cl::opt<double> POPPredicateProbability(
    "pop-pred-prob",
    cl::desc("Probability that the opaque predicate evaluates to true (0-100)"),
    cl::init(0.9999999999998),
    cl::cat(PassCategory)
);

// Number of obfuscation runs per function
cl::opt<unsigned int> POPRunsPerFunction(
    "pop-runs-per-fn",
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
    cl::init(7),
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

            // For safe modification during iteration
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

                // Check if function uses setjmp
                if (Fn->hasFnAttribute(Attribute::ReturnsTwice)) continue;

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

                        if (&BB == &Fn->getEntryBlock()) continue;

                        // We have to guarantee that this random place is after all PHI instructions
                        auto It = BB.getFirstInsertionPt();

                        // BB is either empty or malformed
                        if (It == BB.end()) continue;

                        for (; It != BB.end(); It++)
                            ValidInsertionPts.push_back(It);
                    }

                    if (ValidInsertionPts.empty())
                    {
                        // errs() << "Warning: No valid insertion points found in function " << demangle(Fn->getName()) << " - skipping.\n";
                        continue;
                    }
                    // errs() << "Obfuscating function " << demangle(Fn->getName()) << "\n";
                    
                    const auto RandomInsertionIdx = std::uniform_int_distribution(static_cast<size_t>(0), 
                    ValidInsertionPts.size() - 1)(Rng);
                    const auto RandomInsertionPt = ValidInsertionPts[RandomInsertionIdx];
                    auto RandomBasicBlock = (*RandomInsertionPt).getParent();

                    IRB.SetInsertPoint(RandomInsertionPt);
                    
                    // Freeze parameter to stop propagation of undef and poison values
                    Value* FrozenParameter = IRB.CreateFreeze(Parameter, "frozen_param");

                    // Cast parameter to int
                    Value* IntegerParameter = Utils::CastIRValueToI64(FrozenParameter, IRB);

                    // Hashing to get uniform distribution
                    // The value chosen isn't represented in the binary since clang optimizes it
                    Value* ConstHash = ConstantInt::get(IRB.getInt64Ty(), 6364136223846793005ULL); // Knuth's constant; TODO: make random
                    Value* HashedParameter = IRB.CreateMul(IntegerParameter, ConstHash);

                    // Construct a double using IEEE 754 bit manipulation
                    // Value* MantissaMask = ConstantInt::get(IRB.getInt64Ty(), 0x000FFFFFFFFFFFFFULL);
                    // Value* ExponentBits = ConstantInt::get(IRB.getInt64Ty(), 0x3FF0000000000000ULL); // Exponent for 1.0
                    
                    // Value* Mantissa = IRB.CreateAnd(HashedParam, MantissaMask);
                    // Value* IEEEBits = IRB.CreateOr(Mantissa, ExponentBits);
                    
                    // Value* OneRangeDouble = IRB.CreateBitCast(IEEEBits, IRB.getDoubleTy()); // [1.0; 2.0[
                    // Value* ConstOne = ConstantFP::get(IRB.getDoubleTy(), 1.0);
                    
                    // Get result in [0.0; 1.0[
                    // const auto SmallCallParameter = IRB.CreateFSub(OneRangeDouble, ConstOne);

                    // Get result in [0.0; 1.0[
                    const auto DoubleCallParameter = Utils::CastIRValueToDouble(HashedParameter, IRB);
                    const auto SmallCallParameter = IRB.CreateFDiv(
                        DoubleCallParameter, 
                        ConstantFP::get(IRB.getDoubleTy(), static_cast<double>(UINT64_MAX))
                    );

                    // Generate random inverse CDF
                    const auto [SamplerFn, Bernsteinpolynomial, DomainStart, DomainEnd] = 
                        Distribution::InsertRandomBernsteinNewtonRaphson(M, *Fn, Rng);

                    // i64 x = sampler(u)
                    const auto SampleRet = IRB.CreateCall(SamplerFn, { SmallCallParameter });

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
                        double OffsetY = CurrentY - static_cast<double>(POPPredicateProbability.getValue());
                        
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
                    if (PredicateType) // Always true predicate
                    {
                        // if x <= Threshold...
                        CmpResult = IRB.CreateFCmpULE(SampleRet,
                            ConstantFP::get(IRB.getDoubleTy(), Threshold));
                    }
                    else // Always false predicate
                    {
                        // if x > Threshold...
                        CmpResult = IRB.CreateFCmpUGT(SampleRet,
                            ConstantFP::get(IRB.getDoubleTy(), Threshold));
                    }

                    // Create new BasicBlocks for branches
                    BasicBlock* FakeBB = BasicBlock::Create(LLVMCtx, "never_hit", Fn);
                    IRB.SetInsertPoint(FakeBB);
                    IRB.CreateIntrinsic(Intrinsic::trap, {}, {});
                    if (Fn->getReturnType()->isVoidTy()) 
                        IRB.CreateRetVoid();
                    else 
                        IRB.CreateRet(Constant::getNullValue(Fn->getReturnType()));

                    // Ensure IRB is pointing to the end of our inserted instructions
                    IRB.SetInsertPoint(RandomBasicBlock); 
                    Instruction* SplitPoint = &*IRB.GetInsertPoint(); // Points to the instruction after our logic

                    BasicBlock* RealBB = RandomBasicBlock->splitBasicBlock(RandomInsertionPt, "always_hit");
                    
                    // Replace the br LLVM added with conditional brach.
                    RandomBasicBlock->getTerminator()->eraseFromParent();
                    
                    // Insert Opaque Predicate
                    IRB.SetInsertPoint(RandomBasicBlock); // Sets to end (now valid, since terminator is gone)
                    
                    Value* ThresholdConst = ConstantFP::get(IRB.getDoubleTy(), Threshold);

                    if (PredicateType)
                    {
                        auto CmpResult = IRB.CreateFCmpULE(SampleRet, ThresholdConst);
                        IRB.CreateCondBr(CmpResult, RealBB, FakeBB);
                    } 
                    else
                    {
                        auto CmpResult = IRB.CreateFCmpOGT(SampleRet, ThresholdConst);
                        IRB.CreateCondBr(CmpResult, FakeBB, RealBB);
                    }
                }

                // Mark function as obfuscated so that the loop doesn't run infinitely
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