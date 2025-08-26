#pragma once
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/IntrinsicInst.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Constants.h>
#include <llvm/Pass.h>
#include <llvm/IR/PassManager.h>
#include <llvm/Passes/PassBuilder.h>
#include <llvm/Passes/PassPlugin.h>
#include <llvm/Support/raw_ostream.h>

using namespace llvm;

inline CallInst* insertPrintDouble(Module& M, IRBuilder<>& IRB, Value* Dbl)
{
    LLVMContext& C = M.getContext();
    if (!Dbl || !Dbl->getType()->isDoubleTy())
    {
        report_fatal_error("insertPrintDouble: unsupported parameter type");
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

namespace Distribution
{
    FunctionCallee Create(Module& M, Value* Lambda);
}