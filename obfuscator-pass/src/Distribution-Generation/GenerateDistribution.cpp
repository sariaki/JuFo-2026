#include "GenerateDistribution.hpp"

// https://luc.devroye.org/chapter_ten.pdf
// https://llvm.org/docs/tutorial/MyFirstLanguageFrontend/LangImpl07.html
void InsertBasis(Module& M, std::string DistributionName)
{
    // TODO
}

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
    While u > s:
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

    // Choose a number used to partition the interval into equal chunks
    //const int ChunkCount = std::uniform_int_distribution(10, 30)(Rng);
    //const int ChunkLength = static_cast<int>(DomainEnd - DomainStart) / ChunkCount;
    const int Degree = 10;
    const double ChunkLength = 0.1;

    // Generate random points of a CDF; make sure it's strictly monotonically increasing
    // (If we instead just generated a monotonically increasing CDF, it wouldn't be bijective <=> it wouldn't have an inverse)
    std::vector<double> Xs;
    std::vector<double> Ys;

    // CDF must start with 0
    Xs.push_back(DomainStart);
    Ys.push_back(0);
    
    for (int i = 1; i < Degree; i++)
    {
        double CurrentPos = DomainStart + i * ChunkLength;
        Xs.push_back(CurrentPos);

        // Generate random point
        //double CurrentYCoord = std::uniform_real_distribution(static_cast<double>(i - 1) / Degree, 
        //    static_cast<double>(i) / Degree)(Rng);
        double CurrentYCoord = std::uniform_real_distribution(Ys.back(),
            static_cast<double>(i) / Degree)(Rng);
        Ys.push_back(CurrentYCoord);
    }

    // CDF must end with 1
    Xs.push_back(DomainEnd);
    Ys.push_back(1);

    auto BernsteinRegression = MonotonicBernsteinNNLS(Degree);
    if (!BernsteinRegression.Fit(Xs, Ys)) // NOTE: This will almost never perfectly fit
    {
        //report_fatal_error("Distribution::CreateRandom: failed to fit (perfect) monotonic Bernstein function to points\n");
    }

    const std::vector<double>& Coefficients = BernsteinRegression.GetCoefficients();
    for (int i = 0; i < Degree; i++)
    {
        errs() << Coefficients[i] << ",";
    }
    errs() << "\n";

    // Build Bernstein Polynomial
    errs() << "B_" + std::to_string(Degree) + "(x) = ";
    for (int i = 0; i < Coefficients.size(); i++)
    {
        errs() << "(" + std::to_string(Degree) + ", " + std::to_string(i) + ") * ";
        errs() << "x^" + std::to_string(i) + " * (1-x)^" + std::to_string(Degree - i) + " + ";
    }

    // Compile Bernsteinpolynomial to LLVM-IR
    LLVMContext& LLVMCtx = M.getContext();
    IRBuilder<> IRB(LLVMCtx);

    // Declare sampler function: inline i64 sample_poisson(double)
    FunctionType* FT = FunctionType::get(IRB.getInt64Ty(),
        { IRB.getDoubleTy() }, false);
    FunctionCallee SamplerCallee = M.getOrInsertFunction("sample_random", FT);
    Function* SamplerFn = cast<Function>(SamplerCallee.getCallee());

    SamplerFn->addFnAttr(Attribute::AttrKind::AlwaysInline);

    // Get function argument: double u
    Argument* UniformArg = &*SamplerFn->arg_begin();
    UniformArg->setName("u");

    // Create BasicBlocks for loop
    BasicBlock* EntryBB = BasicBlock::Create(LLVMCtx, "entry", SamplerFn); // We need this for Phi nodes to work
    BasicBlock* LoopBB = BasicBlock::Create(LLVMCtx, "loop", SamplerFn);
    BasicBlock* ExitBB = BasicBlock::Create(LLVMCtx, "exit", SamplerFn);

    /*
    p = 
    s = p
    */

    IRB.SetInsertPoint(EntryBB);
    Utils::PrintIRDouble(M, IRB, UniformArg, "UniformArg: ");
    

    return SamplerCallee;
}