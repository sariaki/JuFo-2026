#pragma once
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/IntrinsicInst.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Constants.h>
#include <vector>
#include "../Distribution-Generation/BernsteinPolynomialRegression.hpp"

using namespace llvm;

namespace Utils
{
    Value* CastIRValueToDouble(Value* V, IRBuilder<>& B, bool IsSigned = true);
    CallInst* PrintIRDouble(Module& M, IRBuilder<>& IRB, Value* DoubleValue, std::string Message);
    //const std::vector<double>& FitBernsteinPolynomial(const std::vector<double>& Xs, const std::vector<double>& Ys, std::int8_t Degree);
}