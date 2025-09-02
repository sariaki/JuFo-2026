#include "Utils.hpp"

Value* Utils::CastIRValueToDouble(Value* V, IRBuilder<>& B, bool isSignedInt)
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
        if (isSignedInt)
            return B.CreateSIToFP(V, doubleTy, "sitofp_to_double");
        else
            return B.CreateUIToFP(V, doubleTy, "uitofp_to_double");
    }
    else if (srcTy->isPointerTy())
    {
        IntegerType* intptrTy = Type::getInt64Ty(C);
        Value* intVal = B.CreatePtrToInt(V, intptrTy, "ptrtoint");
        if (isSignedInt)
            return B.CreateSIToFP(intVal, doubleTy, "ptrsitofp_to_double");
        else
            return B.CreateUIToFP(intVal, doubleTy, "ptruitofp_to_double");
    }
    else
    {
        report_fatal_error("Utils::CastIRValueToDouble: unsupported source type");
    }
}

CallInst* Utils::PrintIRDouble(Module& M, IRBuilder<>& IRB, Value* Dbl)
{
    LLVMContext& C = M.getContext();
    if (!Dbl || !Dbl->getType()->isDoubleTy())
    {
        report_fatal_error("Utils::PrintIRDouble: unsupported parameter type");
    }

    Type* i32Ty = Type::getInt32Ty(C);
    Type* i8PtrTy = Type::getInt8Ty(C)->getPointerTo();
    FunctionType* printfTy = FunctionType::get(i32Ty, { i8PtrTy }, /*isVarArg=*/true);
    FunctionCallee Callee = M.getOrInsertFunction("printf", printfTy);

    Value* Fmt = IRB.CreateGlobalStringPtr("u=%0.17g\n", "fmt_u");

    SmallVector<Value*, 2> Args;
    Args.push_back(Fmt);
    Args.push_back(Dbl);

    CallInst* CallInst = IRB.CreateCall(Callee, Args);
    return CallInst;
}