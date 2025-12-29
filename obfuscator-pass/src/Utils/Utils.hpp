#pragma once
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/IntrinsicInst.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Constants.h>
#include <llvm/Transforms/Utils/Cloning.h>
#include <vector>
#include "../Distribution-Generation/Bernsteinpolynomial.hpp"

using namespace llvm;

namespace Utils
{
    Value* CastIRValueToDouble(Value* V, IRBuilder<>& B, bool IsSigned = true);
    CallInst* PrintfIR(Module& M, IRBuilder<>& IRB, StringRef Format, ArrayRef<Value*> Args = {}) ;
    double BinomialCoefficient(int n, int k);
    bool HasAnnotation(Function *F, std::string_view Annotation);
    bool IsDerivedFromExternalFn(Value *V, SmallPtrSetImpl<Value*> &Visited, int Depth = 0);
    Function* AddLLVMFnArgument(Function *OldFunc, Type *NewArgType, StringRef Name, Value *NewArgValue);
}