#include "GenerateDistribution.hpp"

void InsertBasis(Module& M, std::string DistributionName)
{
    // TODO
}

// For testing
FunctionCallee Distribution::CreatePoisson(Module& M, Value* Lambda)
{
    LLVMContext& LLVMCtx = M.getContext();
    IRBuilder<> IRB(LLVMCtx);

    // Declare sampler function: inline i64 sample_poisson(double)
    FunctionType* FT = FunctionType::get(IRB.getInt64Ty(),
        { IRB.getDoubleTy() }, false);
    FunctionCallee SamplerCallee = M.getOrInsertFunction("sample_poisson", FT);
    Function* SamplerFn = cast<Function>(SamplerCallee.getCallee());

    SamplerFn->addFnAttr(Attribute::AttrKind::AlwaysInline);

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

    /* Knuth's Algorithm: find a valid (possion distributed) k that has the cumulative probability u
    k = 0
    p = e^{-\lambda}
    s = p
    While s < u:
        k = k + 1
        p = p * lambda / k
        s = s + p
    return k
    */

    // Let p_0 = e^{-\lambda}
    // TODO: Do exp() call at compile time
    IRB.SetInsertPoint(EntryBB);
    Utils::PrintIRDouble(M, IRB, UniformArg, "UniformArg: ");
    Value* NegLambda = IRB.CreateFNeg(Lambda);
    Value* P0 = IRB.CreateCall(ExpFn, { NegLambda }, "p0");

    IRB.CreateBr(LoopBB);
    IRB.SetInsertPoint(LoopBB);

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
    Value* CmpRes = IRB.CreateFCmpOGT(UniformArg,Sum);
    IRB.CreateCondBr(CmpRes, LoopBB, ExitBB);

    // Return k_next (since k would only get updated next iteration)
    IRB.SetInsertPoint(ExitBB);
    IRB.CreateRet(IteratorNext);

    return SamplerCallee;
}

FunctionCallee Distribution::CreateRandom(Module& M, std::mt19937 Rng)
{
    // Choose random interval as the CDF's domain
    //const double DomainStart = std::uniform_real_distribution(0.0, 50.0)(Rng);
    //const double DomainEnd = std::uniform_real_distribution(DomainStart, 150.0)(Rng);
    const double DomainStart = 0.0;
    const double DomainEnd = 1.0;

    // Construct random Bernsteinpolynomial s.t. it is...
    // ...monotonically increasing and goes through (0|0) && (0|1)
    const int Degree = 10;
    const int N = Degree + 1;
    auto Bernsteinpolynomial = MonotonicBernstein(Degree, Rng);

    const std::vector<double>& Coefficients = Bernsteinpolynomial.GetRandomCoefficients();
    for (int i = 0; i < N; i++)
    {
        errs() << Coefficients[i] << ",";
    }
    errs() << "\n";

    // Build Bernstein Polynomial
    //errs() << "B_" + std::to_string(Degree) + "(x) = ";
    //for (int i = 0; i < Coefficients.size(); i++)
    //{
    //    errs() << Coefficients[i] << " * ";
    //    errs() << "x^" + std::to_string(i) + " * (1-x)^" + std::to_string(Degree - i) + " + ";
    //}

    // Compile Bernsteinpolynomial to LLVM-IR
    LLVMContext& LLVMCtx = M.getContext();
    IRBuilder<> IRB(LLVMCtx);

    Type* DoubleTy = IRB.getDoubleTy();

    // Declare sampler function: inline i64 sample_random(double)
    FunctionType* FT = FunctionType::get(IRB.getInt64Ty(),
        { DoubleTy }, false);
    FunctionCallee SamplerCallee = M.getOrInsertFunction("sample_random", FT);
    Function* SamplerFn = cast<Function>(SamplerCallee.getCallee());

    //SamplerFn->addFnAttr(Attribute::AttrKind::AlwaysInline);

    // Get function argument: double u
    Argument* UniformArg = &*SamplerFn->arg_begin();
    UniformArg->setName("u");

    // Create BasicBlocks for loop
    BasicBlock* EntryBB = BasicBlock::Create(LLVMCtx, "entry", SamplerFn); // We need this for Phi nodes to work
    BasicBlock* LoopBB = BasicBlock::Create(LLVMCtx, "loop", SamplerFn);
    BasicBlock* ExitBB = BasicBlock::Create(LLVMCtx, "exit", SamplerFn);

    IRB.SetInsertPoint(EntryBB);

    // Convert coeffs to ConstantFPs
    std::vector<Constant*> IRCoefficients;
    IRCoefficients.reserve(N + 1);
    for (int i = 0; i <= Degree; ++i)
        IRCoefficients.push_back(ConstantFP::get(DoubleTy, Coefficients[i]));

    // Compute 1.0 - u
    Value* UValue = UniformArg;
    Value* OneMinusU = IRB.CreateFSub(ConstantFP::get(DoubleTy, 1.0), UValue, "one_minus_u");

    // Compute all the powers of u
    std::vector<Value*> UPowers(N + 1);
    UPowers[0] = ConstantFP::get(DoubleTy, 1.0);
    for (int i = 1; i <= Degree; ++i)
    {
        UPowers[i] = IRB.CreateFMul(UPowers[i - 1], UValue, Twine("u_pow_") + Twine(i));
    }

    // Compute all of the powers of (1-u)
    std::vector<Value*> OneMinusUPowers(N + 1);
    OneMinusUPowers[0] = ConstantFP::get(DoubleTy, 1.0);
    for (int i = 1; i <= Degree; ++i)
    {
        OneMinusUPowers[i] = IRB.CreateFMul(OneMinusUPowers[i - 1], OneMinusU, Twine("omu_pow_") + Twine(i));
    }

    IRB.CreateBr(LoopBB);
    IRB.SetInsertPoint(LoopBB);

    /*
        s = 0
        k = 0
        While s < u:
            s = s + bernstein(k)
            k = k + 1
        return k - 1
    */
    PHINode* Iterator = IRB.CreatePHI(IRB.getInt64Ty(), 2, "k");
    PHINode* Sum = IRB.CreatePHI(IRB.getDoubleTy(), 2, "s");
    Iterator->addIncoming(ConstantInt::get(IRB.getInt64Ty(), 0), EntryBB);
    Sum->addIncoming(ConstantFP::get(DoubleTy, 0.0), EntryBB);
    
    // Compute resulting polynomial: s = sum_{i=0..n-1} coeff[i] * u^i * (1-u)^(n-i)
    Value* SumNext = ConstantFP::get(DoubleTy, 0.0);
    for (int i = 0; i <= Degree; ++i)
    {
        // coeff[i] * u_pow[i] * omu_pow_[n-i]
        Value* T = IRB.CreateFMul(IRCoefficients[i], UPowers[i], Twine("term_cu_") + Twine(i));
        T = IRB.CreateFMul(T, OneMinusUPowers[Degree - i], Twine("term_") + Twine(i));
        SumNext = IRB.CreateFAdd(Sum, T, Twine("acc_") + Twine(i));
    }

    Value* IteratorNext = IRB.CreateAdd(Iterator, ConstantInt::get(IRB.getInt64Ty(), 1));

    // Update values
    Iterator->addIncoming(IteratorNext, LoopBB);
    Sum->addIncoming(SumNext, LoopBB);

    // If u > s: goto ExitBB else: goto LoopBB
    Value* CmpRes = IRB.CreateFCmpOGT(UniformArg, Sum);
    IRB.CreateCondBr(CmpRes, LoopBB, ExitBB);

    // Return k
    IRB.SetInsertPoint(ExitBB);
    IRB.CreateRet(Iterator);

    //Utils::PrintIRDouble(M, IRB, Result, "bernstein: ");

    return SamplerCallee;
}