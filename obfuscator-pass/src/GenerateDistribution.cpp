#include "GenerateDistribution.hpp"

FunctionCallee Disitrubtion::Create(Module& M)
{
    LLVMContext& LLVMCtx = M.getContext();
    IRBuilder<> IRB(LLVMCtx);

    // Declare sampler function: double sample_poisson(double)
    FunctionCallee Sampler = M.getOrInsertFunction(
        "sample_poisson", Type::getDoubleTy(LLVMCtx), Type::getDoubleTy(LLVMCtx)
    );
    auto SamplerFn = M.getFunction("sample_poisson"); // FunctionCallee doesn't hold the actual function

    // Insert at entry block
    BasicBlock& Entry = SamplerFn->getEntryBlock();
    IRB.SetInsertPoint(&Entry);

    

    return Sampler;
}