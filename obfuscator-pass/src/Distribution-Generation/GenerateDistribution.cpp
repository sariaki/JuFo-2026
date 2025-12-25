#include "GenerateDistribution.hpp"

// For testing
FunctionCallee Distribution::CreatePoissonFn(Module& M, Value* Lambda)
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
std::tuple<FunctionCallee, MonotonicBernstein, double, double> Distribution::CreateRandomBernsteinBinarySearchFn(Module& M, std::mt19937 Rng)
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
    FunctionCallee SamplerCallee = M.getOrInsertFunction("sample_bernstein_inv_binarysearch", FT);
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

std::tuple<FunctionCallee, MonotonicBernstein, double, double> Distribution::CreateRandomBernsteinNewtonRaphsonFn(Module& M, std::mt19937 Rng)
{
    // Choose random interval as the CDF's domain
    const double VerticalStretch = std::uniform_real_distribution(0.01, 50.0)(Rng);
    const double HorizontalShift = std::uniform_real_distribution(-50.0, 50.0)(Rng);
    const double DomainStart = HorizontalShift;
    const double DomainEnd = HorizontalShift + (1.0 / VerticalStretch);
    
    // Start the Newton guess exactly in the middle
    const double InitialGuess = HorizontalShift + (0.5 / VerticalStretch);

    // Construct random Bernsteinpolynomial B(Degree, a * (x - k)) s.t. it is
    // monotonically increasing and goes through (k | 0) && (k + 1/a | 1)
    const int Degree = 3; //std::uniform_int_distribution(3, 50)(Rng);
    const int n = Degree + 1;
    auto Bernsteinpolynomial = MonotonicBernstein(Degree, Rng, VerticalStretch, HorizontalShift);
    
    const std::vector<double>& Coefficients = Bernsteinpolynomial.GetRandomCoefficients();

    // Pre-calculate the derivative's coefficients of B(x)
    // b_v'(x) = n * (b_{v-1}(x) - b_v(x))
    std::vector<double> DerivativeCoefficients  = Bernsteinpolynomial.GetDerivativeCoefficients();

    // Compile Bernsteinpolynomial to LLVM-IR
    LLVMContext& LLVMCtx = M.getContext();
    IRBuilder<> IRB(LLVMCtx);

    Type* DoubleTy = IRB.getDoubleTy();

    // Create Function: double sample(double u)
    FunctionType* FT = FunctionType::get(DoubleTy, { DoubleTy }, false);
    FunctionCallee SamplerCallee = M.getOrInsertFunction("sample_bernstein_newtonraphson", FT);
    Function* SamplerFn = cast<Function>(SamplerCallee.getCallee());

    // Get function argument: double u in [0;1]
    Argument* TargetProb = &*SamplerFn->arg_begin();
    TargetProb->setName("u");

    // Create BasicBlocks for loop
    BasicBlock* EntryBB = BasicBlock::Create(LLVMCtx, "entry", SamplerFn);
    BasicBlock* LoopBB = BasicBlock::Create(LLVMCtx, "loop", SamplerFn);
    BasicBlock* ExitBB = BasicBlock::Create(LLVMCtx, "exit", SamplerFn);
    
    IRB.SetInsertPoint(EntryBB);
    
    // Constants
    Value* ConstVertStretch = ConstantFP::get(DoubleTy, VerticalStretch);
    Value* ConstHorizShift  = ConstantFP::get(DoubleTy, HorizontalShift);
    Value* ConstOne = ConstantFP::get(DoubleTy, 1.0);
    Value* ConstZero = ConstantFP::get(DoubleTy, 0.0);
    Value* ConstStartGuess = ConstantFP::get(DoubleTy, InitialGuess);

    IRB.CreateBr(LoopBB);

    IRB.SetInsertPoint(LoopBB);

    // Initialize Phi nodes: Current X estimate, Iteration Counter
    PHINode* CurrentX = IRB.CreatePHI(DoubleTy, 2);
    PHINode* IterCounter  = IRB.CreatePHI(IRB.getInt32Ty(), 2);

    CurrentX->addIncoming(ConstStartGuess, EntryBB);
    IterCounter->addIncoming(IRB.getInt32(0), EntryBB);

    // t = a * (x - k)
    Value* XMinusK = IRB.CreateFSub(CurrentX, ConstHorizShift);
    Value* ATimesXMinusK = IRB.CreateFMul(XMinusK, ConstVertStretch);
    Value* One_minus_T = IRB.CreateFSub(ConstOne, ATimesXMinusK);

    // Compute Polynomial B(t) and Derivative B'(t)
    // by unrolling loop into a chain of instructions,
    // making the function look like a block of heavy arithmetic
    
    Value* AccumulatorAntiDerv = ConstZero;// B(t)
    Value* AccumulatorDerv = ConstZero; // Stores B'(t) (without chain rule factor)

    // Helper to compute power: x^p (unrolled)
    auto CreatePow = [&](Value* Base, int Power) -> Value* 
    {
        if (Power == 0) return ConstOne;

        Value* Res = Base;
        for (int i = 1; i < Power; ++i) 
            Res = IRB.CreateFMul(Res, Base);

        return Res;
    };

    // Compute B(t) = sum( Coeffs[i] * Binom * t^i * (1-t)^(n-i) )
    for (int i = 0; i <= Degree; ++i) 
    {
        double Binom = Utils::BinomialCoefficient(Degree, i);
        
        if (Binom == 0.0) continue;

        Value* TermVal = ConstantFP::get(DoubleTy, Coefficients[i] * Binom);
        
        // Optimize: Don't multiply by 1.0
        Value* T_Part = (i == 0) ? ConstOne : CreatePow(ATimesXMinusK, i);
        Value* OneT_Part = (Degree - i == 0) ? ConstOne : CreatePow(One_minus_T, Degree - i);

        Value* Term = IRB.CreateFMul(TermVal, T_Part);
        Term = IRB.CreateFMul(Term, OneT_Part);
        AccumulatorAntiDerv = IRB.CreateFAdd(AccumulatorAntiDerv, Term);
    }

    // Calculate B'(t) using precomputed derivative coefficients (Degree - 1)
    // B'(t) = n * sum( (C_{i+1}-C_i) * Binom(n-1, i) * t^i * (1-t)^(n-1-i) )
    for (int i = 0; i < Degree; ++i) 
    {
        double Binom = Utils::BinomialCoefficient(Degree - 1, i);

        if (Binom == 0.0) continue;

        Value* TermVal = ConstantFP::get(DoubleTy, DerivativeCoefficients[i] * Binom);

        Value* T_Part = (i == 0) ? ConstOne : CreatePow(ATimesXMinusK, i);
        Value* OneT_Part = (Degree - 1 - i == 0) ? ConstOne : CreatePow(One_minus_T, Degree - 1 - i);

        Value* Term = IRB.CreateFMul(TermVal, T_Part);
        Term = IRB.CreateFMul(Term, OneT_Part);
        AccumulatorDerv = IRB.CreateFAdd(AccumulatorDerv, Term);
    }

    // Newton Step
    // f(x) = B(t) - u = 0 ==> root
    // f'(x) = B'(t) * (dt/dx) = B'(t) * VerticalStretch
    // x_new = x - (B(t) - u) / (B'(t) * VerticalStretch)
    Value* F = IRB.CreateFSub(AccumulatorAntiDerv, TargetProb); // B(t) - u
    Value* FDerv = IRB.CreateFMul(AccumulatorDerv, ConstVertStretch); // Chain rule applied
    
    // Update Bounds
    Value* Step = IRB.CreateFDiv(F, FDerv);
    Value* NextX = IRB.CreateFSub(CurrentX, Step);

    // Update Loop Variables
    Value* NextIter = IRB.CreateAdd(IterCounter, IRB.getInt32(1));
    CurrentX->addIncoming(NextX, LoopBB);
    IterCounter->addIncoming(NextIter, LoopBB);

    // Exit after 16 iterations
    Value* Done = IRB.CreateICmpEQ(NextIter, IRB.getInt32(16));
    IRB.CreateCondBr(Done, ExitBB, LoopBB);

    IRB.SetInsertPoint(ExitBB);
    IRB.CreateRet(NextX);

    return { SamplerCallee, Bernsteinpolynomial, DomainStart, DomainEnd };
}

static int InsertedFns = 0;
std::tuple<FunctionCallee, MonotonicBernstein, double, double> Distribution::InsertRandomBernsteinNewtonRaphson(Module &M, Function& Where, std::mt19937 Rng)
{
    InsertedFns++;
    // Choose random interval as the CDF's domain
    const double VerticalStretch = std::uniform_real_distribution(0.01, 50.0)(Rng);
    const double HorizontalShift = std::uniform_real_distribution(-50.0, 50.0)(Rng);
    const double DomainStart = HorizontalShift;
    const double DomainEnd = HorizontalShift + (1.0 / VerticalStretch);
    
    // Start the Newton guess exactly in the middle
    const double InitialGuess = HorizontalShift + (0.5 / VerticalStretch);

    // Construct random Bernsteinpolynomial B(Degree, a * (x - k)) s.t. it is
    // monotonically increasing and goes through (k | 0) && (k + 1/a | 1)
    const int Degree = std::uniform_int_distribution(POPMinDegree.getValue(), POPMaxDegree.getValue())(Rng);
    const int n = Degree + 1;
    auto Bernsteinpolynomial = MonotonicBernstein(Degree, Rng, VerticalStretch, HorizontalShift);
    
    const std::vector<double>& Coefficients = Bernsteinpolynomial.GetRandomCoefficients();

    // Pre-calculate the derivative's coefficients of B(x)
    // b_v'(x) = n * (b_{v-1}(x) - b_v(x))
    std::vector<double> DerivativeCoefficients  = Bernsteinpolynomial.GetDerivativeCoefficients();

    // Compile Bernsteinpolynomial to LLVM-IR
    LLVMContext& LLVMCtx = M.getContext();
    IRBuilder<> IRB(LLVMCtx);

    Type* DoubleTy = IRB.getDoubleTy();

    // Create Function: double sample(double u)
    FunctionType* FT = FunctionType::get(DoubleTy, { DoubleTy }, false);
    FunctionCallee SamplerCallee = M.getOrInsertFunction("sample_bernstein_newtonraphson_" + demangle(Where.getName()) + std::to_string(InsertedFns), FT);
    Function* SamplerFn = cast<Function>(SamplerCallee.getCallee());

    SamplerFn->setLinkage(GlobalValue::PrivateLinkage);
    SamplerFn->addFnAttr(Attribute::AlwaysInline); 

    // Get function argument: double u in [0;1]
    Argument* TargetProb = &*SamplerFn->arg_begin();
    TargetProb->setName("u");

    // Create BasicBlocks for loop
    BasicBlock* EntryBB = BasicBlock::Create(LLVMCtx, "entry", SamplerFn);
    BasicBlock* LoopBB = BasicBlock::Create(LLVMCtx, "loop", SamplerFn);
    BasicBlock* ExitBB = BasicBlock::Create(LLVMCtx, "exit", SamplerFn);
    
    IRB.SetInsertPoint(EntryBB);
    
    // Constants
    Value* ConstVertStretch = ConstantFP::get(DoubleTy, VerticalStretch);
    Value* ConstHorizShift  = ConstantFP::get(DoubleTy, HorizontalShift);
    Value* ConstOne = ConstantFP::get(DoubleTy, 1.0);
    Value* ConstZero = ConstantFP::get(DoubleTy, 0.0);
    Value* ConstStartGuess = ConstantFP::get(DoubleTy, InitialGuess);
    Value* ConstDomainEnd = ConstantFP::get(DoubleTy, DomainEnd);

    IRB.CreateBr(LoopBB);

    IRB.SetInsertPoint(LoopBB);

    // Initialize Phi nodes: Current X estimate, Iteration Counter
    PHINode* CurrentX = IRB.CreatePHI(DoubleTy, 2);
    PHINode* IterCounter  = IRB.CreatePHI(IRB.getInt32Ty(), 2);

    CurrentX->addIncoming(ConstStartGuess, EntryBB);
    IterCounter->addIncoming(IRB.getInt32(0), EntryBB);

    // t = a * (x - k)
    Value* XMinusK = IRB.CreateFSub(CurrentX, ConstHorizShift);
    Value* ATimesXMinusK = IRB.CreateFMul(XMinusK, ConstVertStretch);
    Value* One_minus_T = IRB.CreateFSub(ConstOne, ATimesXMinusK);

    // Compute Polynomial B(t) and Derivative B'(t)
    // by unrolling loop into a chain of instructions,
    // making the function look like a block of heavy arithmetic
    
    Value* AccumulatorAntiDerv = ConstZero;// B(t)
    Value* AccumulatorDerv = ConstZero; // Stores B'(t) (without chain rule factor)

    // Helper to compute power: x^p (unrolled)
    auto CreatePow = [&](Value* Base, int Power) -> Value* 
    {
        if (Power == 0) return ConstOne;

        Value* Res = Base;
        for (int i = 1; i < Power; ++i) 
            Res = IRB.CreateFMul(Res, Base);

        return Res;
    };

    // Compute B(t) = sum( Coeffs[i] * Binom * t^i * (1-t)^(n-i) )
    for (int i = 0; i <= Degree; ++i) 
    {
        double Binom = Utils::BinomialCoefficient(Degree, i);
        
        if (Binom == 0.0) continue;

        Value* TermVal = ConstantFP::get(DoubleTy, Coefficients[i] * Binom);
        
        // Optimize: Don't multiply by 1.0
        Value* T_Part = (i == 0) ? ConstOne : CreatePow(ATimesXMinusK, i);
        Value* OneT_Part = (Degree - i == 0) ? ConstOne : CreatePow(One_minus_T, Degree - i);

        Value* Term = IRB.CreateFMul(TermVal, T_Part);
        Term = IRB.CreateFMul(Term, OneT_Part);
        AccumulatorAntiDerv = IRB.CreateFAdd(AccumulatorAntiDerv, Term);
    }

    // Calculate B'(t) using precomputed derivative coefficients (Degree - 1)
    // B'(t) = n * sum( (C_{i+1}-C_i) * Binom(n-1, i) * t^i * (1-t)^(n-1-i) )
    for (int i = 0; i < Degree; ++i) 
    {
        double Binom = Utils::BinomialCoefficient(Degree - 1, i);

        if (Binom == 0.0) continue;

        Value* TermVal = ConstantFP::get(DoubleTy, DerivativeCoefficients[i] * Binom);

        Value* T_Part = (i == 0) ? ConstOne : CreatePow(ATimesXMinusK, i);
        Value* OneT_Part = (Degree - 1 - i == 0) ? ConstOne : CreatePow(One_minus_T, Degree - 1 - i);

        Value* Term = IRB.CreateFMul(TermVal, T_Part);
        Term = IRB.CreateFMul(Term, OneT_Part);
        AccumulatorDerv = IRB.CreateFAdd(AccumulatorDerv, Term);
    }

    // Newton Step
    // f(x) = B(t) - u = 0 ==> root
    // f'(x) = B'(t) * (dt/dx) = B'(t) * VerticalStretch
    // x_new = x - (B(t) - u) / (B'(t) * VerticalStretch)
    Value* OffsetY = IRB.CreateFSub(AccumulatorAntiDerv, TargetProb); // B(t) - u
    Value* Slope = IRB.CreateFMul(AccumulatorDerv, ConstVertStretch); // Chain rule applied
    
    // Update Bounds
    Value* Step = IRB.CreateFDiv(OffsetY, Slope);
    Value* NextX = IRB.CreateFSub(CurrentX, Step);

    // Clamp Max
    // if (NextX > DomainEnd) NextX = DomainEnd;
    // TODO: Make this not get compiled to fmax/fmin
    Value* TooHigh = IRB.CreateFCmpOGT(NextX, ConstDomainEnd);
    Value* ClampedHigh = IRB.CreateSelect(TooHigh, ConstDomainEnd, NextX);

    // Clamp Min: if (NextX < DomainStart) NextX = DomainStart;
    Value* TooLow = IRB.CreateFCmpOLT(ClampedHigh, ConstHorizShift);
    Value* ClampedFinal = IRB.CreateSelect(TooLow, ConstHorizShift, ClampedHigh);

    // Update Loop Variables
    Value* NextIter = IRB.CreateAdd(IterCounter, IRB.getInt32(1));
    CurrentX->addIncoming(ClampedFinal, LoopBB);
    IterCounter->addIncoming(NextIter, LoopBB);

    // Exit after fixed amount of iterations
    Value* Done = IRB.CreateICmpEQ(NextIter, IRB.getInt32(POPNewtonRaphsonIterations));
    IRB.CreateCondBr(Done, ExitBB, LoopBB);

    IRB.SetInsertPoint(ExitBB);
    // Utils::PrintfIR(M, IRB, "NextX: %f.\n", NextX);
    IRB.CreateRet(NextX);

    return { SamplerCallee, Bernsteinpolynomial, DomainStart, DomainEnd };
}