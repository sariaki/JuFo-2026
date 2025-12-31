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
#include <llvm/Demangle/Demangle.h>
#include <random>
#include <limits>
#include "../Utils/Utils.hpp"
#include "Bernsteinpolynomial.hpp"
#include "../Parameters.hpp"

using namespace llvm;

namespace Distribution
{
    FunctionCallee CreatePoissonFn(Module& M, Value* Lambda);
    std::tuple<FunctionCallee, MonotonicBernstein, double, double> CreateRandomBernsteinBinarySearchFn(Module& M, std::mt19937 Rng);
    std::tuple<FunctionCallee, MonotonicBernstein, double, double> InsertRandomBernsteinNewtonRaphson(Module& M, Function& Where, std::mt19937 Rng);
}