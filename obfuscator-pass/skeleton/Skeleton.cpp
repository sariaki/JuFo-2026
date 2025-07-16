#include "llvm/Passes/PassPlugin.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Demangle/Demangle.h"

using namespace llvm;

namespace {
    struct SkeletonPass : PassInfoMixin<SkeletonPass>
    {
        PreservedAnalyses run(Function& F, FunctionAnalysisManager&)
        {
            if (F.isDeclaration()) return PreservedAnalyses::all();

            std::string demangled = llvm::demangle(F.getName().str());
            errs() << "[SkeletonPass] Function: " << (demangled.empty() ? F.getName() : demangled) << "\n";

            return PreservedAnalyses::all();
        }
    };
} // end anonymous namespace

extern "C" ::llvm::PassPluginLibraryInfo LLVM_ATTRIBUTE_WEAK llvmGetPassPluginInfo() {
    llvm::errs() << "SkeletonPass plugin loaded!\n"; // Debug output
    return {
        LLVM_PLUGIN_API_VERSION, "SkeletonPass", "v0.1",
        [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                    if (Name == "skeleton-pass") {
                        llvm::errs() << "SkeletonPass registered in pipeline!\n"; // Debug
                        FPM.addPass(SkeletonPass());
                        return true;
                    }
                    return false;
                });
        }};
}