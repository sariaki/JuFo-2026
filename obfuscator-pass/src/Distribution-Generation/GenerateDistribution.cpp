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

// cf. https://www.desmos.com/calculator/dyhao2ofgd
std::tuple<FunctionCallee, MonotonicBernstein, double, double> Distribution::CreateRandom(Module& M, std::mt19937 Rng)
{
    // Choose random interval as the CDF's domain
    const double VerticalStretch = std::uniform_real_distribution(0.01, 50.0)(Rng);
    const double HorizontalShift = std::uniform_real_distribution(-50.0, 50.0)(Rng);
    const double DomainStart = HorizontalShift;
    const double DomainEnd = HorizontalShift + (1.0 / VerticalStretch);

    // Construct random Bernsteinpolynomial B(Degree, a * (x - k)) s.t. it is
    // monotonically increasing and goes through (k | 0) && (k + 1/a | 1)
    const int Degree = 3; //std::uniform_int_distribution(3, 50)(Rng);
    const int n = Degree + 1;
    auto Bernsteinpolynomial = MonotonicBernstein(Degree, Rng, VerticalStretch, HorizontalShift);
    
    const std::vector<double>& Coefficients = Bernsteinpolynomial.GetRandomCoefficients();

    // Compile Bernsteinpolynomial to LLVM-IR
    LLVMContext& LLVMCtx = M.getContext();
    IRBuilder<> IRB(LLVMCtx);

    Type* DoubleTy = IRB.getDoubleTy();

    FunctionType* FT = FunctionType::get(DoubleTy, 
        { DoubleTy }, false);
    FunctionCallee SamplerCallee = M.getOrInsertFunction("sample_bernstein_inverse", FT);
    Function* SamplerFn = cast<Function>(SamplerCallee.getCallee());

    // SamplerFn->addFnAttr(Attribute::AlwaysInline); 

    // Get function argument: double u in [0;1]
    Argument* TargetProb = &*SamplerFn->arg_begin();
    TargetProb->setName("u");

    // Create BasicBlocks for loop
    BasicBlock* EntryBB = BasicBlock::Create(LLVMCtx, "entry", SamplerFn);
    BasicBlock* LoopBB  = BasicBlock::Create(LLVMCtx, "loop", SamplerFn);
    BasicBlock* ExitBB  = BasicBlock::Create(LLVMCtx, "exit", SamplerFn);

    IRB.SetInsertPoint(EntryBB);
    
    // Constants
    Value* ConstDomainStart = ConstantFP::get(DoubleTy, DomainStart);
    Value* ConstDomainEnd   = ConstantFP::get(DoubleTy, DomainEnd);
    
    IRB.CreateBr(LoopBB);
    IRB.SetInsertPoint(LoopBB);

    // Create Phi Node vars' initial values
    PHINode* Low = IRB.CreatePHI(DoubleTy, 2, "low");
    PHINode* High = IRB.CreatePHI(DoubleTy, 2, "high");
    PHINode* Iter = IRB.CreatePHI(IRB.getInt32Ty(), 2, "iter");

    // Initialize Phi nodes
    Low->addIncoming(ConstDomainStart, EntryBB);
    High->addIncoming(ConstDomainEnd, EntryBB);
    Iter->addIncoming(IRB.getInt32(0), EntryBB);

    // Mid = (Low + High) * 0.5
    Value* Sum = IRB.CreateFAdd(Low, High);
    Value* Mid = IRB.CreateFMul(Sum, ConstantFP::get(DoubleTy, 0.5), "mid");

    // Compute B(a * (Mid - k))

    // t = a * (Mid - k)
    Value* MidMinusK = IRB.CreateFSub(Mid, ConstantFP::get(DoubleTy, HorizontalShift));
    Value* ATimesMidMinusK = IRB.CreateFMul(ConstantFP::get(DoubleTy, VerticalStretch), MidMinusK);
    
    // 1.0 - t
    Value* OneMinusT = IRB.CreateFSub(ConstantFP::get(DoubleTy, 1.0), ATimesMidMinusK);

    // (1-t)^Degree by repeated multiplication
    Value* PowOneMinusT = ConstantFP::get(DoubleTy, 1.0);
    for (unsigned i = 0; i < Degree; i++)
    {
        PowOneMinusT = IRB.CreateFMul(PowOneMinusT, OneMinusT);
    }

    // t^i by repeated multiplication
    Value* PowT = ConstantFP::get(DoubleTy, 1.0);

    // Accumulator for Bernstein Fn
    Value* PolyResult = ConstantFP::get(DoubleTy, 0.0);

    for (unsigned i = 0; i <= Degree; i++)
    {
        // Coeff * Binom * t^i * (1-t)^{n-i}
        double Binom = Utils::BinomialCoefficient(Degree, i);
        double Val = Coefficients[i] * Binom;
        Value* CoeffTerm = ConstantFP::get(DoubleTy, Val);  

        Value* Term = IRB.CreateFMul(CoeffTerm, PowT);
        Term = IRB.CreateFMul(Term, PowOneMinusT);
        PolyResult = IRB.CreateFAdd(PolyResult, Term);  

        // Update powers for next iteration...
        if (i < Degree) {
            PowT = IRB.CreateFMul(PowT, ATimesMidMinusK); // t_i = t_{i-1} * t
            PowOneMinusT = IRB.CreateFDiv(PowOneMinusT, OneMinusT); // (1-t)_i = (1-t)_{i-1} / (1-t)
        }
    }

    // Update Bounds
    // If PolyResult < TargetProb: too low => Low = Mid
    // Else: too high => High = Mid
    Value* TooLow = IRB.CreateFCmpOLT(PolyResult, TargetProb, "is_too_low");
    
    Value* NextLow  = IRB.CreateSelect(TooLow, Mid, Low, "next_low");
    Value* NextHigh = IRB.CreateSelect(TooLow, High, Mid, "next_high");

    Low->addIncoming(NextLow, LoopBB);
    High->addIncoming(NextHigh, LoopBB);

    // Exit after 64 iterations
    // we've achieved full double precision accuracy
    Value* NextIter = IRB.CreateAdd(Iter, IRB.getInt32(1));
    Iter->addIncoming(NextIter, LoopBB);

    Value* Done = IRB.CreateICmpEQ(NextIter, IRB.getInt32(64));
    IRB.CreateCondBr(Done, ExitBB, LoopBB);

    IRB.SetInsertPoint(ExitBB);
    IRB.CreateRet(NextLow);

    return { SamplerCallee, Bernsteinpolynomial, DomainStart, DomainEnd };
}