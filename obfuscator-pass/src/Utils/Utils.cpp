#include "Utils.hpp"

Value* Utils::CastIRValueToDouble(Value* V, IRBuilder<>& B, bool IsSigned)
{
    Type* srcTy = V->getType();
    LLVMContext& C = srcTy->getContext();
    Type* doubleTy = Type::getDoubleTy(C);

    if (srcTy == doubleTy)
    {
        return V;
    }
    else if (srcTy->isFloatTy())
    {
        return B.CreateFPExt(V, doubleTy, "fpext_to_double");
    }
    else if (srcTy->isIntegerTy())
    {
        if (IsSigned)
            return B.CreateSIToFP(V, doubleTy, "sitofp_to_double");
        else
            return B.CreateUIToFP(V, doubleTy, "uitofp_to_double");
    }
    else if (srcTy->isPointerTy())
    {
        IntegerType* intptrTy = Type::getInt64Ty(C);
        Value* intVal = B.CreatePtrToInt(V, intptrTy, "ptrtoint");
        if (IsSigned)
            return B.CreateSIToFP(intVal, doubleTy, "ptrsitofp_to_double");
        else
            return B.CreateUIToFP(intVal, doubleTy, "ptruitofp_to_double");
    }
    else
    {
        report_fatal_error("Utils::CastIRValueToDouble: unsupported source type\n");
    }
}

CallInst* Utils::PrintfIR(Module& M, IRBuilder<>& IRB, StringRef Format, ArrayRef<Value*> Args) 
{
    LLVMContext& C = M.getContext();

    if (!IRB.GetInsertBlock()) {
        report_fatal_error("Utils::Printf: IRBuilder has no insertion point\n");
        return nullptr;
    }

    // Manually create the Global Variable for the format string.
    Constant *StrConstant = ConstantDataArray::getString(C, Format);
    
    // Check if this string already exists to avoid bloating the module
    GlobalVariable *FmtStrGV = M.getGlobalVariable(("fmt_" + Format).str(), true);
    
    if (!FmtStrGV) {
        FmtStrGV = new GlobalVariable(
            M,
            StrConstant->getType(),
            true,
            GlobalValue::PrivateLinkage,
            StrConstant,
            "fmt_str"
        );
        FmtStrGV->setUnnamedAddr(GlobalValue::UnnamedAddr::Global);
    }

    // Prepare printf arguments
    std::vector<Value*> FinalArgs;
    
    Value* FmtPtr = IRB.CreateInBoundsGEP(
        FmtStrGV->getValueType(), // The array type ([N x i8])
        FmtStrGV,                 // The pointer to the array
        { IRB.getInt64(0), IRB.getInt64(0) }, // Indices: [0, 0]
        "fmt_ptr"
    );
    
    FinalArgs.push_back(FmtPtr);

    // Process Variable Arguments
    for (Value* Arg : Args) {
        Type* Ty = Arg->getType();

        if (Ty->isFloatingPointTy()) 
        {
            if (Ty->isFloatTy() || Ty->isHalfTy() || Ty->isBFloatTy())
                FinalArgs.push_back(IRB.CreateFPExt(Arg, Type::getDoubleTy(C)));
            else
                FinalArgs.push_back(Arg);
        } 
        else if (Ty->isIntegerTy()) 
        {
            if (Ty->getIntegerBitWidth() < 32)
                FinalArgs.push_back(IRB.CreateZExt(Arg, Type::getInt32Ty(C)));
            else
                FinalArgs.push_back(Arg);
        } 
        else
            // Pointers and others pass through (Opaque Pointers handle the types)
            FinalArgs.push_back(Arg);
    }

    FunctionType* PrintfTy = FunctionType::get(
        Type::getInt32Ty(C), 
        { PointerType::getUnqual(C) },
        true 
    );
    
    FunctionCallee PrintfFunc = M.getOrInsertFunction("printf", PrintfTy);
    return IRB.CreateCall(PrintfFunc, FinalArgs);
}

double Utils::BinomialCoefficient(int n, int k)
{
    if (k > n || k < 0) return 0.0;
    if (k == 0 || k == n) return 1.0;

    double Result = 1.0;
    for (int i = 1; i <= k; ++i)
    {
        Result = Result * (n - k + i) / i;
    }
    return Result;
}

bool Utils::HasAnnotation(Function *F, std::string_view Annotation)
{
    Module* M = F->getParent();

    GlobalVariable* Glob = M->getGlobalVariable("llvm.global.annotations");
    if (!Glob) return false;

    auto* CA = dyn_cast<ConstantArray>(Glob->getInitializer());
    if (!CA) return false;

    for (unsigned i = 0; i < CA->getNumOperands(); ++i) 
    {
        auto* Struct = dyn_cast<ConstantStruct>(CA->getOperand(i));
        if (!Struct) continue;

        // First field is the function pointer
        auto* FuncPtr = dyn_cast<Function>(Struct->getOperand(0)->stripPointerCasts());
        
        // Second field is the annotation string
        auto* GStr = dyn_cast<GlobalVariable>(Struct->getOperand(1)->stripPointerCasts());
        
        if (FuncPtr == F && GStr) 
        {
            auto* Data = dyn_cast<ConstantDataArray>(GStr->getInitializer());
            if (Data && Data->getAsCString() == Annotation.data()) 
                return true;
        }
    }

    return false;
}