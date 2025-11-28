#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/NoFolder.h>
#include <llvm/IR/IntrinsicInst.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Constants.h>
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

namespace
{
    struct StochasticOpaquePredicate : public PassInfoMixin<StochasticOpaquePredicate>
    {
        const double Threshold = 140;
        const double Lambda = 100;

        PreservedAnalyses run(Module& M, ModuleAnalysisManager& AM)
        {
            LLVMContext& LLVMCtx = M.getContext();
            IRBuilder<NoFolder> IRB(LLVMCtx);
            IRB.clearFastMathFlags();

            std::random_device Dev;
            std::mt19937 Rng(Dev());

            //const auto Sampler = Distribution::CreatePoisson(M, ConstantFP::get(IRB.getDoubleTy(), Lambda));
            //const auto [SamplerFn, Bernsteinpolynomial] = Distribution::CreateRandom(M, Rng);

            for (Function& F : M)
            {
                // Check if our function is defined and not just declared
                if (F.isDeclaration()) continue;

                // Check if function has required annotation
                // TODO
                if (!(demangle(F.getName().str()) == "foo"))
                    continue;


                // Insert at entry block
                BasicBlock& EntryBB = F.getEntryBlock();
                IRB.SetInsertPoint(EntryBB.getFirstInsertionPt());
               
                // TODO: Multiple Methods for getting randomness

                // Get Parameter to create a symbolic variable for the solver
                if (F.arg_empty())
                    continue;

                auto Two = ConstantFP::get(IRB.getFloatTy(), APFloat(2.0));
                auto One = ConstantFP::get(IRB.getFloatTy(), APFloat(1.0));
                Value* OneMinusU = IRB.CreateFSub(Two, One, "oneMinusU");

                //if (DISubprogram* SP = F.getSubprogram())
                //{
                //    DebugLoc DL = DebugLoc(DILocation::get(LLVMCtx,/*line*/ 1, /*col*/ 0, SP));   // choose sensible line/col
                //    // Option A: set builder's current location before creating the call
                //    IRB.SetCurrentDebugLocation(DL);
                //    Value* ci = Utils::PrintIRDouble(M, IRB, Two, "OneMinusU: ");
                //    // Optionally clear it afterwards:
                //    IRB.SetCurrentDebugLocation(DebugLoc());
                //    // Option B: or set it on the call after creation
                //    if (auto* CI = dyn_cast_or_null<CallInst>(ci))
                //        CI->setDebugLoc(DL);
                //}

                // Cast the variable to a double
                //const auto DoubleCallParameter = Utils::CastIRValueToDouble(&*F.arg_begin(), IRB);

                //// Make variable lie in [0;1]
                //// We do this this way because LLVM *somehow* messes up if we perform a division with IRB.CreateFDiv in the IR
                //constexpr double RecipMax = 1.0 / std::numeric_limits<double>::max();
                //Value* RecipMaxConstant = ConstantFP::get(IRB.getDoubleTy(), RecipMax);

                //const auto SmallCallParameter = IRB.CreateFMul(DoubleCallParameter, RecipMaxConstant);

                //// i64 x = sampler(u))
                //const auto SampleRet = IRB.CreateCall(SamplerFn, { SmallCallParameter });
                ////const auto SampleRet = IRB.CreateCall(Sampler, { SmallCallParameter });

                //// Compute needed threshold for bernsteinpolynomial
                //double Threshold = 0.99;
                ////for (double i = 0.0; i < 1.0; i += 0.01)
                ////{
                ////    if (Bernsteinpolynomial.EvaluateAt(i) > 0.99)
                ////    {
                ////        Threshold = i;
                ////        break;
                ////    }
                ////}

                //// if x < Threshold...
                ////const auto CmpResult = IRB.CreateICmpSLT(SampleRet,
                ////    ConstantInt::get(IRB.getInt64Ty(), Threshold));
                //const auto CmpResult = IRB.CreateFCmpOLT(SampleRet,
                //    ConstantFP::get(IRB.getDoubleTy(), Threshold));
                //
                //// Create new BasicBlocks for branches
                //const auto TrueBB = SampleRet->getParent()->splitBasicBlock(IRB.GetInsertPoint(), "always_hit");
                //const auto FalseBB = BasicBlock::Create(LLVMCtx, "never_hit", &F);

                //// Replace terminator of entry BasicBlock (unconditional br added by splitBasicBlock) with ours
                //EntryBB.getTerminator()->eraseFromParent();
                //IRB.SetInsertPoint(&EntryBB);
                //IRB.CreateCondBr(CmpResult, TrueBB, FalseBB);

                //IRB.SetInsertPoint(FalseBB);
                //IRB.CreateUnreachable(); // TODO
            }

            return PreservedAnalyses::all();
        }
    };

#pragma region Setup Boilerplate
    // Legacy PassManager registration
    struct LegacyStochasticOpaquePredicate : public ModulePass
    {
        static char ID;
        LegacyStochasticOpaquePredicate() : ModulePass(ID)
        {}
        bool runOnModule(Module& M) override
        {
            auto& P = *new StochasticOpaquePredicate();
            ModuleAnalysisManager MAM;
            P.run(M, MAM);
            return true;
        }
    };
}

char LegacyStochasticOpaquePredicate::ID = 0;
static RegisterPass<LegacyStochasticOpaquePredicate> X(
    "stoch-opaque", "Inject stochastic opaque predicates", false, false
);

// New PassManager registration
extern "C" llvm::PassPluginLibraryInfo getStochasticOpaquePredicatePluginInfo()
{
    return 
    { 
        LLVM_PLUGIN_API_VERSION, "StochasticOpaquePredicates", "v0.1", 
        [](PassBuilder& PB)
        {
            PB.registerPipelineParsingCallback([](StringRef Name, ModulePassManager& MPM, ...)
            {
                if (Name == "obfuscator")
                {
                    MPM.addPass(StochasticOpaquePredicate());
                    return true;
                }
                return false;
            });
        }
    };
}

extern "C" LLVM_ATTRIBUTE_WEAK::llvm::PassPluginLibraryInfo
    llvmGetPassPluginInfo()
{
    return getStochasticOpaquePredicatePluginInfo();
}
#pragma endregion