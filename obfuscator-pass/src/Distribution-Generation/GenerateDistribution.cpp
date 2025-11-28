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
    Iterator->addIncoming(IRB.getInt64(0), EntryBB);
    Prob->addIncoming(P0, EntryBB);
    Sum->addIncoming(P0, EntryBB);

    // k_next = k + 1
    Value* IteratorNext = IRB.CreateAdd(Iterator, IRB.getInt64(1));
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

std::pair<FunctionCallee, MonotonicBernstein> Distribution::CreateRandom(Module& M, std::mt19937 Rng)
{
    // Choose random interval as the CDF's domain
    //const double DomainStart = std::uniform_real_distribution(0.0, 50.0)(Rng);
    //const double DomainEnd = std::uniform_real_distribution(DomainStart, 150.0)(Rng);
    const double DomainStart = 0.0;
    const double DomainEnd = 1.0;

    // Construct random Bernsteinpolynomial s.t. it is...
    // ...monotonically increasing and goes through (0|0) && (0|1)
    const int Degree = 4;
    const int N = Degree + 1;
    auto Bernsteinpolynomial = MonotonicBernstein(Degree, Rng);

    const std::vector<double>& Coefficients = {0.0, 0.1, 0.6, 0.9, 1.0};
    //const std::vector<double>& Coefficients = Bernsteinpolynomial.GetRandomCoefficients();

    // Compile Bernsteinpolynomial to LLVM-IR
    LLVMContext& LLVMCtx = M.getContext();
    IRBuilder<> IRB(LLVMCtx);

    Type* DoubleTy = IRB.getDoubleTy();

    // Declare sampler function: inline i64 sample_bernstein(double)
    FunctionType* FT = FunctionType::get(DoubleTy,
        { DoubleTy }, false);
    FunctionCallee SamplerCallee = M.getOrInsertFunction("sample_bernstein", FT);
    Function* SamplerFn = cast<Function>(SamplerCallee.getCallee());

    //SamplerFn->addFnAttr(Attribute::AttrKind::AlwaysInline);

    // Get function argument: double u
    Argument* UniformArg = &*SamplerFn->arg_begin();
    UniformArg->setName("u");

    // Create BasicBlocks for loop
    BasicBlock* EntryBB = BasicBlock::Create(LLVMCtx, "entry", SamplerFn);

    IRB.SetInsertPoint(EntryBB);

    // Convert Coeffs into IR
    std::vector<Constant*> IRCoefficients;
    for (int i = 0; i <= Degree; i++)
    {
        IRCoefficients.push_back(ConstantFP::get(IRB.getDoubleTy(), Coefficients[i]));
    }

    // 1.0 - u
    Value* OneMinusU = IRB.CreateFSub(ConstantFP::get(DoubleTy, APFloat::getOne(APFloat::IEEEdouble())), UniformArg, "oneMinusU");
    //// (1-u)^Degree by repeated multiplication
    //Value* PowOneMinusU = ConstantFP::get(DoubleTy, 1.0);
    //for (unsigned i = 0; i < Degree; i++)
    //{
    //    PowOneMinusU = IRB.CreateFMul(PowOneMinusU, OneMinusU, "powOneMinusU_mul");
    //}

    //// Compute u^i by repeated multiplication with u each iteration
    //Value* PowU = ConstantFP::get(DoubleTy, 1.0);

    //// Accumulator for Bernstein Fn
    //Value* Result = ConstantFP::get(DoubleTy, 0.0);

    //// Precompute coeff_i * binomial_i
    //std::vector<double> BinomMulCoeff(N);
    //for (unsigned i = 0; i <= Degree; i++)
    //{
    //    double BinomialCoefficient = Utils::BinomialCoefficient(Degree, i);
    //    BinomMulCoeff[i] = Coefficients[i] * BinomialCoefficient;
    //}

    //// For each i:
    //// term = coeff_i * binom_i * powU_i * powOneMinusU_i
    //// bernstein_poly_res += term
    //// powU *= u                    # u^i         -> u^{i+1}
    //// powOneMinusU /= oneMinusU    # (1-u)^{n-i} -> (1-u)^{n-(i+1)}
    //for (unsigned i = 0; i <= Degree; i++)
    //{
    //    // Precomputed constant
    //    Value* Coeff = ConstantFP::get(DoubleTy, BinomMulCoeff[i]);

    //    // NextTerm = Coeff * u^i
    //    Value* NextTerm = IRB.CreateFMul(Coeff, PowU, "t_mul_c_powU");

    //    // NextTerm = NextTerm * (1-u)^i
    //    NextTerm = IRB.CreateFMul(NextTerm, PowOneMinusU, "t_mul_powOneMinusU");

    //    Result = IRB.CreateFAdd(Result, NextTerm, "accum");

    //    // update powU = powU * u
    //    if (i < Degree) // no need to update after last iteration
    //        PowU = IRB.CreateFMul(PowU, UniformArg, "powU_next");

    //    // update powOneMinusU = powOneMinusU / oneMinusU  (if oneMinusU == 0 this is runtime NaN/Inf)
    //    if (i < Degree)
    //        PowOneMinusU = IRB.CreateFDiv(PowOneMinusU, OneMinusU, "powOneMinusU_div");
    //}

    IRB.CreateRet(OneMinusU);

    return { SamplerCallee, Bernsteinpolynomial };
}