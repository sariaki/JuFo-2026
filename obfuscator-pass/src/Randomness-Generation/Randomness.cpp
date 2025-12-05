#include "Randomness.hpp"

FunctionCallee Random::CreateHash(Module& M, std::mt19937 Rng)
{
    LLVMContext& LLVMCtx = M.getContext();
    IRBuilder<> IRB(LLVMCtx);

    FunctionType* FT = FunctionType::get(IRB.getInt64Ty(), false);
    FunctionCallee SamplerCallee = M.getOrInsertFunction("prng", FT);
    Function* SamplerFn = cast<Function>(SamplerCallee.getCallee());

    SamplerFn->addFnAttr(Attribute::AttrKind::AlwaysInline);

    // Create BasicBlocks for loop
    BasicBlock* EntryBB = BasicBlock::Create(LLVMCtx, "entry", SamplerFn); // We need this for Phi nodes to work
    BasicBlock* LoopBB = BasicBlock::Create(LLVMCtx, "loop", SamplerFn);
    BasicBlock* ExitBB = BasicBlock::Create(LLVMCtx, "exit", SamplerFn);

    /* Xorshift-PRNG:
    
        hash = const
        for i=0..len:
        (1):    hash = hash * const
        (2):    hash = hash + input[i]
        
        hash ^= 13
    */

    IRB.SetInsertPoint(EntryBB);
    Value* HashInitial = IRB.getInt64(std::uniform_int_distribution(0, 
        std::numeric_limits<int>::max())(Rng));

    IRB.CreateBr(LoopBB);
    IRB.SetInsertPoint(LoopBB);

    PHINode* Iterator = IRB.CreatePHI(IRB.getInt64Ty(), 2, "i");
    PHINode* Hash = IRB.CreatePHI(IRB.getInt64Ty(), 2, "hash");

    Iterator->addIncoming(IRB.getInt64(0), EntryBB);
    Hash->addIncoming(HashInitial, EntryBB);

    Value* HashNew1 = IRB.CreateMul(Hash, IRB.getInt64(
        std::uniform_int_distribution(0, std::numeric_limits<int>::max())(Rng)));

    // Get input[i]
    llvm::Value* Shifted = IRB.CreateLShr(Hash, Iterator, "shifted");
    llvm::Value* Bit = IRB.CreateAnd(Shifted,
        llvm::ConstantInt::get(IRB.getInt64Ty(), 1), "bit");
    llvm::Value* Bit_i = IRB.CreateTrunc(Bit, IRB.getInt1Ty(), "bit_i");

    Value* HashNew2 = IRB.CreateAdd(HashNew1, Bit_i);

    Value* IteratorNext = IRB.CreateAdd(Iterator, IRB.getInt64(1));

    // Update values
    Iterator->addIncoming(IteratorNext, LoopBB);
    Hash->addIncoming(HashNew2, LoopBB);

    Value* CmpRes = IRB.CreateICmpSLT(Iterator, IRB.getInt64(static_cast<int64_t>(1) << 64)); // 1 << 64 = 2**64
    IRB.CreateCondBr(CmpRes, LoopBB, ExitBB);

    IRB.SetInsertPoint(ExitBB);
    IRB.CreateRet(HashNew2);

    return SamplerCallee;
}

FunctionCallee Random::CreateHardwareUniform(Module& M)
{
    LLVMContext& LLVMCtx = M.getContext();
    IRBuilder<> IRB(LLVMCtx);

    FunctionType* FT = FunctionType::get(IRB.getDoubleTy(), false);
    FunctionCallee UniformCallee = M.getOrInsertFunction("hw_uniform01", FT);
    Function* UniformFn = cast<Function>(UniformCallee.getCallee());

    UniformFn->addFnAttr(Attribute::AttrKind::AlwaysInline);

    BasicBlock* EntryBB = BasicBlock::Create(LLVMCtx, "entry", UniformFn);
    IRB.SetInsertPoint(EntryBB);

    return UniformCallee;
}
