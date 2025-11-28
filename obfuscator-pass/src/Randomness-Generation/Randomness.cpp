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

    // Collect varying hardware/OS state (cycle counter, stack slot, callee address).
    Function* ReadCycleFn = Intrinsic::getDeclaration(&M, Intrinsic::readcyclecounter);
    Value* Cycle = IRB.CreateCall(ReadCycleFn, {}, "cycle");

    AllocaInst* Probe = IRB.CreateAlloca(IRB.getInt8Ty(), nullptr, "probe");
    Value* StackBits = IRB.CreatePtrToInt(Probe, IRB.getInt64Ty(), "stack_bits");
    Value* SelfBits = IRB.CreatePtrToInt(UniformFn, IRB.getInt64Ty(), "fn_bits");

    Value* Mix0 = IRB.CreateXor(Cycle, StackBits, "mix0");
    Value* Mix1 = IRB.CreateAdd(Mix0, SelfBits, "mix1");

    Function* BswapFn = Intrinsic::getDeclaration(&M, Intrinsic::bswap, {IRB.getInt64Ty()});
    Value* Scrambled = IRB.CreateCall(BswapFn, {Mix1}, "scrambled");

    Function* PopcountFn = Intrinsic::getDeclaration(&M, Intrinsic::ctpop, {IRB.getInt64Ty()});
    Value* Pop = IRB.CreateCall(PopcountFn, {Scrambled}, "pop");

    Value* ShiftAmt32 = IRB.CreateTrunc(Pop, IRB.getInt32Ty(), "shift_amt32");
    Value* ShiftAmt = IRB.CreateZExt(ShiftAmt32, IRB.getInt64Ty(), "shift_amt");
    Value* ShiftMask = IRB.CreateAnd(ShiftAmt, IRB.getInt64(63), "shift_mask");

    Value* Left = IRB.CreateShl(Scrambled, ShiftMask, "rot_left");
    Value* ComplementShift = IRB.CreateAnd(IRB.CreateSub(IRB.getInt64(64), ShiftMask), IRB.getInt64(63));
    Value* Right = IRB.CreateLShr(Scrambled, ComplementShift, "rot_right");
    Value* Rot = IRB.CreateOr(Left, Right, "rot");

    Value* Mix2 = IRB.CreateXor(Rot, IRB.CreateLShr(StackBits, IRB.getInt64(1)), "mix2");
    Value* Mix3 = IRB.CreateAdd(Mix2, IRB.CreateShl(SelfBits, IRB.getInt64(1)), "mix3");
    Value* Mixed = IRB.CreateXor(Mix3, Cycle, "mixed");

    Value* IsZero = IRB.CreateICmpEQ(Mixed, IRB.getInt64(0), "mixed_zero");
    Value* MixedSel = IRB.CreateSelect(IsZero, IRB.CreateXor(StackBits, SelfBits), Mixed, "mixed_sel");

    // Reinterpret truncated random mantissa over exponent bits from 1.0 and subtract 1.0 to get [0,1).
    Value* OneDouble = IRB.CreateSIToFP(IRB.getInt64(1), IRB.getDoubleTy(), "one_double");
    Value* OneBits = IRB.CreateBitCast(OneDouble, IRB.getInt64Ty(), "one_bits");
    Value* Mantissa = IRB.CreateLShr(MixedSel, IRB.getInt64(12), "mantissa");
    Value* CombinedBits = IRB.CreateOr(OneBits, Mantissa, "combined_bits");
    Value* CombinedDouble = IRB.CreateBitCast(CombinedBits, IRB.getDoubleTy(), "combined_double");
    Value* Uniform = IRB.CreateFSub(CombinedDouble, OneDouble, "uniform");

    IRB.CreateRet(Uniform);

    return UniformCallee;
}
