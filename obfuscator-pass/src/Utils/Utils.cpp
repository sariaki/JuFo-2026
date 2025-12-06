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

// TODO: Generalize this
CallInst* Utils::PrintIRDouble(Module& M, IRBuilder<>& IRB, Value* DoubleValue, std::string Message)
{
//#ifdef _DEBUG
    LLVMContext& C = M.getContext();
    if (!DoubleValue || !DoubleValue->getType()->isDoubleTy())
    {
        report_fatal_error("Utils::PrintIRDouble: unsupported parameter type\n");
    }

    Type* i32Ty = Type::getInt32Ty(C);
    Type* i8PtrTy = Type::getInt8Ty(C)->getPointerTo();
    FunctionType* printfTy = FunctionType::get(i32Ty, { i8PtrTy }, /*isVarArg=*/true);
    FunctionCallee Callee = M.getOrInsertFunction("printf", printfTy);

    Value* Fmt = IRB.CreateGlobalStringPtr(Message.append("%0.17g\n"), "fmt_u");

    SmallVector<Value*, 2> Args;
    Args.push_back(Fmt);
    Args.push_back(DoubleValue);

    CallInst* CallInst = IRB.CreateCall(Callee, Args);
    return CallInst;
//#else
//    return reinterpret_cast<CallInst*>(0);
//#endif
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