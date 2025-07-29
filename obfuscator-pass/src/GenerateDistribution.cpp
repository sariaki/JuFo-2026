#include "GenerateDistribution.hpp"

// https://luc.devroye.org/chapter_ten.pdf
// https://llvm.org/docs/tutorial/MyFirstLanguageFrontend/LangImpl07.html
FunctionCallee Distribution::Create(Module& M, ConstantFP* Lambda)
{
    LLVMContext& LLVMCtx = M.getContext();
    IRBuilder<> IRB(LLVMCtx);

    // Declare sampler function: double sample_poisson(double)
    FunctionCallee Sampler = M.getOrInsertFunction(
        "sample_poisson", IRB.getDoubleTy(), IRB.getDoubleTy()
    );
    auto SamplerFn = M.getFunction("sample_poisson"); // FunctionCallee doesn't hold the actual function

    // Get exp function
    FunctionCallee ExpFn = M.getOrInsertFunction(
        "exp",
        FunctionType::get(IRB.getDoubleTy(), { IRB.getDoubleTy() }, false)
    );

    // Create BasicBlocks for loop
    BasicBlock* EntryBB = BasicBlock::Create(LLVMCtx, "entry", SamplerFn); // We need this for Phi nodes to work
    BasicBlock* LoopBB = BasicBlock::Create(LLVMCtx, "loop", SamplerFn);
    BasicBlock* ExitBB = BasicBlock::Create(LLVMCtx, "exit", SamplerFn);

    IRB.SetInsertPoint(EntryBB);
    Value* NegLambda = IRB.CreateFNeg(Lambda, "neg_lambda");
    Value* P0 = IRB.CreateCall(ExpFn, { NegLambda }, "p0");

    IRB.CreateBr(LoopBB);

    // Get function argument: double u
    IRB.SetInsertPoint(LoopBB);
    Argument* UniformArg = &*SamplerFn->arg_begin();
    UniformArg->setName("u");

    /* 
        i = 0
        p = e^{-\lambda}
        s = p
        While u > s:
            i = i + 1
            p = p * lambda / i
            s = i * p
        return i
    */

    // Create Phi Node vars
    PHINode* Iterator = IRB.CreatePHI(IRB.getInt64Ty(), 2, "i");
    PHINode* Prob = IRB.CreatePHI(IRB.getDoubleTy(), 2, "p");
    PHINode* Sum = IRB.CreatePHI(IRB.getDoubleTy(), 2, "s");
    Iterator->addIncoming(ConstantInt::get(IRB.getInt64Ty(), 0), EntryBB);
    Prob->addIncoming(P0, EntryBB);
    Sum->addIncoming(P0, EntryBB);



    return Sampler;
}