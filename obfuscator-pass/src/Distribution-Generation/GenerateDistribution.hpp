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
#include <random>
#include <optional>
#include "../Utils/Utils.hpp"
#include "BernsteinPolynomialRegression.hpp"

using namespace llvm;

namespace Distribution
{
    FunctionCallee CreatePoisson(Module& M, Value* Lambda);
    FunctionCallee CreateRandom(Module& M, std::mt19937 Rng);
}