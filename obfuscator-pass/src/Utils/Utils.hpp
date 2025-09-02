#pragma once
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/IntrinsicInst.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Constants.h>

using namespace llvm;

namespace Utils
{
    Value* CastIRValueToDouble(Value* V, IRBuilder<>& B, bool isSignedInt = true);
    CallInst* PrintIRDouble(Module& M, IRBuilder<>& IRB, Value* Dbl);
}