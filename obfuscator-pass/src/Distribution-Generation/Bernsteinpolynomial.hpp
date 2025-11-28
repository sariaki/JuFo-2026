#pragma once
#include <iostream>
#include <vector>
#include <cmath>
#include <string>
#include <random>
#include "../Utils/Utils.hpp"

class MonotonicBernstein
{
private:
    int m_Degree;
    std::vector<double> m_Coefficients;
    std::mt19937 m_Rng;

    double BensteinBasisPolynomial(double x, int i, int n) const;

public:
    MonotonicBernstein(uint64_t Degree, std::mt19937 Rng);

    const std::vector<double>& GetRandomCoefficients();
    const int GetDegree() const;
    const double EvaluateAt(double x) const;
};