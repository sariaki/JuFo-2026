#include "GenerateDistribution.hpp"

// https://luc.devroye.org/chapter_ten.pdf
// https://llvm.org/docs/tutorial/MyFirstLanguageFrontend/LangImpl07.html
FunctionCallee Distribution::Create(Module& M, Value* Lambda)
{
    LLVMContext& LLVMCtx = M.getContext();
    IRBuilder<> IRB(LLVMCtx);

    // Declare sampler function: i64 sample_poisson(double)
    FunctionType* FT = FunctionType::get(IRB.getInt64Ty(),
        { IRB.getBFloatTy()}, false);
    FunctionCallee SamplerCallee = M.getOrInsertFunction("sample_poisson", FT);
    Function* SamplerFn = cast<Function>(SamplerCallee.getCallee());

    // Get exp function
    FunctionCallee ExpFn = M.getOrInsertFunction(
        "exp",
        FunctionType::get(IRB.getDoubleTy(), { IRB.getDoubleTy() }, false)
    );

    // Get function argument: double u
    Argument* UniformArg = &*SamplerFn->arg_begin();
    UniformArg->setName("u");

    // Create BasicBlocks for loop
    BasicBlock* EntryBB = BasicBlock::Create(LLVMCtx, "entry", SamplerFn); // We need this for Phi nodes to work
    BasicBlock* LoopBB = BasicBlock::Create(LLVMCtx, "loop", SamplerFn);
    BasicBlock* ExitBB = BasicBlock::Create(LLVMCtx, "exit", SamplerFn);

    // Let p_0 = e^{-\lambda}
    // TODO: Do exp() call at compile time
    // TODO: Fix NegLambda getting turned into a BFloat16
    IRB.SetInsertPoint(EntryBB);
    Value* NegLambda = IRB.CreateFNeg(Lambda);
    Value* P0 = IRB.CreateCall(ExpFn, { NegLambda }, "p0");

    IRB.CreateBr(LoopBB);
    IRB.SetInsertPoint(LoopBB);

    /* Algorithm: We're essentially just finding a valid k that has the cumulative probability u
        k = 0
        p = e^{-\lambda}
        s = p
        While u > s:
            k = k + 1
            p = p * lambda / k
            s = s + p
        return k
    */

    // Create Phi Node vars' initial values: k=0, p=p_0, s=p_0
    PHINode* Iterator = IRB.CreatePHI(IRB.getInt64Ty(), 2, "k");
    PHINode* Prob = IRB.CreatePHI(IRB.getDoubleTy(), 2, "p");
    PHINode* Sum = IRB.CreatePHI(IRB.getDoubleTy(), 2, "s");
    Iterator->addIncoming(ConstantInt::get(IRB.getInt64Ty(), 0), EntryBB);
    Prob->addIncoming(P0, EntryBB);
    Sum->addIncoming(P0, EntryBB);

    // k_next = k + 1
    Value* IteratorNext = IRB.CreateAdd(Iterator, ConstantInt::get(IRB.getInt64Ty(), 1));
    // p_next = p * lambda / k_next
    Value* LambdaDiv = IRB.CreateFDiv(
        Lambda,
        IRB.CreateSIToFP(IteratorNext, IRB.getDoubleTy())
    );
    Value* ProbNext = IRB.CreateFMul(Prob, LambdaDiv);
    // s_next = s + p_next
    Value* SumNext = IRB.CreateFAdd(Sum, ProbNext);

    // Update values
    Iterator->addIncoming(IteratorNext, LoopBB);
    Prob->addIncoming(ProbNext, LoopBB);
    Sum->addIncoming(SumNext, LoopBB);

    // If u > s: goto ExitBB else: goto LoopBB
    Value* CmpRes = IRB.CreateFCmpOGT(
        IRB.CreateFPExt(UniformArg, IRB.getDoubleTy()), 
        Sum
    );
    IRB.CreateCondBr(CmpRes, LoopBB, ExitBB);

    // Return k_next (since k would only get updated next iteration)
    IRB.SetInsertPoint(ExitBB);
    IRB.CreateRet(IteratorNext);

    return SamplerCallee;
}