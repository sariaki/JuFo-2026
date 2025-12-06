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

            // Generate random inverse CDF
            const auto [SamplerFn, Bernsteinpolynomial, DomainStart, DomainEnd] = Distribution::CreateRandom(M, Rng);

            for (Function& F : M)
            {
                // Check if our function is defined and not just declared
                if (F.isDeclaration()) continue;

                // Check if function has required annotation
                if (!Utils::HasAnnotation(&F, PASS_NAME)) continue;

                errs() << "Running on " << demangle(F.getName()) << "\n";

                // Insert at entry block
                BasicBlock& EntryBB = F.getEntryBlock();
                IRB.SetInsertPoint(EntryBB.getFirstInsertionPt());
               
                // TODO: Multiple Methods for getting randomness

                // Get Parameter to create a symbolic variable for the solver
                if (F.arg_empty())
                    continue;

                // Cast the variable to a double
                const auto DoubleCallParameter = Utils::CastIRValueToDouble(&*F.arg_begin(), IRB);

                // Make variable lie in [0;1]
                // We do this this way because LLVM *somehow* messes up if we perform a division with IRB.CreateFDiv in the IR
                constexpr double RecipMax = 1.0 / std::numeric_limits<double>::max();
                Value* RecipMaxConstant = ConstantFP::get(IRB.getDoubleTy(), RecipMax);

                const auto SmallCallParameter = IRB.CreateFMul(DoubleCallParameter, RecipMaxConstant);

                // i64 x = sampler(u)
                const auto SampleRet = IRB.CreateCall(SamplerFn, { SmallCallParameter });

                errs() << "Start: " << DomainStart << " End: " << DomainEnd << "\n";

                // Compute needed threshold for Bernsteinpolynomial
                double DomainWidth = DomainEnd - DomainStart;
                double StepSize = DomainWidth / 100.0;
                double Threshold = std::numeric_limits<double>::lowest(); // We use this value for debugging purposes (easily identifiable)
                for (double i = DomainStart; i < DomainEnd; i += StepSize)
                {
                   if (Bernsteinpolynomial.EvaluateAt(i) >= 0.9) 
                   {
                       Threshold = i;
                       break;
                   }
                }
                
                errs() << "Threshold: " << Threshold << "\n";

                // if x < Threshold...
                const auto CmpResult = IRB.CreateFCmpOLT(SampleRet,
                   ConstantFP::get(IRB.getDoubleTy(), Threshold));
                
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
}

// New PassManager registration
extern "C" llvm::PassPluginLibraryInfo getProbabilisticOpaquePredicatesPluginInfo()
{
    return 
    { 
        LLVM_PLUGIN_API_VERSION, "ProbabilisticOpaquePredicates", "v0.1", 
        [](PassBuilder& PB)
        {
            PB.registerPipelineParsingCallback([](StringRef Name, ModulePassManager& MPM, ...)
            {
                if (Name == PASS_NAME)
                {
                    MPM.addPass(ProbabilisticOpaquePredicatesPass());
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
    return getProbabilisticOpaquePredicatesPluginInfo();
}