#include <llvm/IR/IRBuilder.h>
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
            IRBuilder<> IRB(LLVMCtx);

            srand(time(0));
            const auto Sampler = Distribution::CreatePoisson(M, ConstantFP::get(IRB.getDoubleTy(), Lambda));

            for (Function& F : M)
            {
                // Check if our function is defined and not just declared
                if (F.isDeclaration()) continue;

                // Check if function has required annotation
                // TODO: improve this ghetto check and check fn attributes
                // This just prevents us from entering an infinite loop
                //if (demangle(F.getName().str()) == "sample_poisson")
                //    continue;
                if (!(demangle(F.getName().str()) == "foo"))
                    continue;

                // Insert at entry block
                BasicBlock& EntryBB = F.getEntryBlock();
                IRB.SetInsertPoint(EntryBB.getFirstInsertionPt());
               
                // i64 x = sample_poisson(rand())
                //const auto CallParameter = ConstantFP::get(IRB.getDoubleTy(), (float)rand() / (RAND_MAX + 1.0f)); // Test pseudo param
                
                // Get Parameter to create a symbolic variable for the solver
                if (F.arg_empty())
                    continue;

                // Cast the variable to a double
                const auto DoubleCallParameter = Utils::CastIRValueToDouble(&*F.arg_begin(), IRB);

                // Make variable lie \in [0;1]
                // We do this this way because LLVM *somehow* messes up if we perform a division with IRB.CreateFDiv in the IR
                constexpr double RecipMax = 1.0 / std::numeric_limits<double>::max();
                Value* RecipMaxConstant = ConstantFP::get(IRB.getDoubleTy(), RecipMax);
                const auto SmallCallParameter = IRB.CreateFMul(DoubleCallParameter, RecipMaxConstant);

                Utils::PrintIRDouble(M, IRB, DoubleCallParameter);
                Utils::PrintIRDouble(M, IRB, SmallCallParameter);

                const auto SampleRet = IRB.CreateCall(Sampler, { SmallCallParameter });

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
                IRB.CreateUnreachable(); // TODO
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