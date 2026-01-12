#pragma once
#include "llvm/Support/CommandLine.h"

using namespace llvm;

// This groups the command-line options for readability
extern cl::OptionCategory PassCategory;

extern cl::opt<unsigned int> POPInsertProbability;
extern cl::opt<double> POPPredicateProbability;
extern cl::opt<unsigned int> POPRunsPerFunction;
extern cl::opt<unsigned int> POPMinDegree;
extern cl::opt<unsigned int> POPMaxDegree;
extern cl::opt<unsigned int> POPNewtonRaphsonIterations;