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
        // User-set threshold for tail probability (e.g., P(X>=T) ~ epsilon)
        int64_t Threshold = 10;
        double Lambda = 0.5; // For Poisson(lambda)

        PreservedAnalyses run(Module& M, ModuleAnalysisManager& AM)
        {
            LLVMContext& LLVMCtx = M.getContext();
            IRBuilder<> IRB(LLVMCtx);

            srand(time(0));

            for (Function& F : M)
            {
                if (F.isDeclaration()) continue;
                //if (!F.hasFnAttribute("insert_stochastic_predicate"))
                //    continue;

                // Insert at entry block
                BasicBlock& Entry = F.getEntryBlock();
                IRB.SetInsertPoint(&Entry);
               
                // i64 x = sample_poisson(rand())
                auto CallParameter = ConstantFP::get(Type::getDoubleTy(LLVMCtx), (double)rand() / (RAND_MAX + 1.0));
                auto SampleRet = IRB.CreateCall(Sampler, {CallParameter});

                // if x < Threshold...
                auto Ult = IRB.CreateFCmpULT(SampleRet, ConstantFP::get(Type::getDoubleTy(LLVMCtx), (double)Threshold));
                
                // Create new BasicBlocks for branches
                auto TrueBB = SampleRet->getParent()->splitBasicBlock(IRB.GetInsertPoint(), "always_hit");
                auto FalseBB = BasicBlock::Create(LLVMCtx, "never_hit", &F);

                // Replace terminator of entry BasicBlock (unconditional br added by splitBasicBlock) with ours
                Entry.getTerminator()->eraseFromParent();
                IRB.SetInsertPoint(&Entry);
                IRB.CreateCondBr(Ult, TrueBB, FalseBB);

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