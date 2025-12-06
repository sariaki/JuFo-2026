#pragma once
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/IntrinsicInst.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Constants.h>
#include <vector>
#include "../Distribution-Generation/Bernsteinpolynomial.hpp"

using namespace llvm;

namespace Utils
{
    Value* CastIRValueToDouble(Value* V, IRBuilder<>& B, bool IsSigned = true);
    CallInst* PrintIRDouble(Module& M, IRBuilder<>& IRB, Value* DoubleValue, std::string Message);
    double BinomialCoefficient(int n, int k);
    bool HasAnnotation(Function *F, std::string_view Annotation);
}