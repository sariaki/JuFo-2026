#pragma once
#include "llvm/Support/CommandLine.h"

using namespace llvm;

// This groups the command-line options for readability
extern cl::OptionCategory PassCategory;

extern cl::opt<unsigned int> POPProbability;
extern cl::opt<unsigned int> POPPredicateProbability;
extern cl::opt<unsigned int> POPRunsPerFunction;
extern cl::opt<unsigned int> POPMinDegree;
extern cl::opt<unsigned int> POPMaxDegree;
extern cl::opt<unsigned int> POPNewtonRaphsonIterations;