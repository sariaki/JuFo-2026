#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/IntrinsicInst.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Constants.h>
#include <llvm/Pass.h>
#include <llvm/IR/PassManager.h>
#include <llvm/Passes/PassBuilder.h>
#include <llvm/Passes/PassPlugin.h>
#include <llvm/Support/raw_ostream.h>
#include <iostream>
#include "GenerateDistribution.hpp"

using namespace llvm;

namespace
{
    struct StochasticOpaquePredicate : public PassInfoMixin<StochasticOpaquePredicate>
    {
        const double Threshold = 0.5;
        PreservedAnalyses run(Module& M, ModuleAnalysisManager& AM)
        {
            LLVMContext& LLVMCtx = M.getContext();
            IRBuilder<> IRB(LLVMCtx);

            srand(time(0));
            const auto Sampler = Distribution::Create(M, ConstantFP::get(IRB.getDoubleTy(), (double)0.42069));

            for (Function& F : M)
            {
                if (F.isDeclaration()) continue;
                //if (!F.hasFnAttribute("insert_stochastic_predicate"))
                //    continue;

                // Insert at entry block
                BasicBlock& EntryBB = F.getEntryBlock();
                IRB.SetInsertPoint(EntryBB.getFirstInsertionPt());
               
                // i64 x = sample_poisson(rand())
                const auto CallParameter = ConstantFP::get(IRB.getBFloatTy(), (float)rand() / (RAND_MAX + 1.0f));
                const auto SampleRet = IRB.CreateCall(Sampler, { CallParameter });

                // if x < Threshold...
                const auto CmpResult = IRB.CreateICmpSLT(SampleRet,
                    ConstantInt::get(IRB.getInt64Ty(), Threshold));
                
                // Create new BasicBlocks for branches
                const auto TrueBB = SampleRet->getParent()->splitBasicBlock(IRB.GetInsertPoint(), "always_hit");
                const auto FalseBB = BasicBlock::Create(LLVMCtx, "never_hit", &F);

                // Replace terminator of entry BasicBlock (unconditional br added by splitBasicBlock) with ours
                EntryBB.getTerminator()->eraseFromParent();
                IRB.SetInsertPoint(&EntryBB);
                IRB.CreateCondBr(CmpResult, TrueBB, FalseBB);

                IRB.SetInsertPoint(FalseBB);
                IRB.CreateUnreachable();
            }

            return PreservedAnalyses::all();
        }
    };

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