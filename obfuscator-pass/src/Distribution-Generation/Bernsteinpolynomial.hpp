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
    std::vector<double> m_DerivativeCoefficients;
    std::mt19937 m_Rng;

    // Transformation parameters
    double m_HorizontalStretch;
    double m_HorizontalShift;

    double BensteinBasisPolynomial(double x, int i, int n) const;
    double BensteinBasisPolynomialDerivative(double x, int i, int n) const;

public:
    MonotonicBernstein(uint64_t Degree, std::mt19937 Rng, double VerticalStretch, double HorizontalShift);

    const std::vector<double>& GetRandomCoefficients();
    const std::vector<double>& GetDerivativeCoefficients() const;

    const int GetDegree() const;
    const int GetHorizontalStretch() const;
    const int GetHorizontalShift() const;

    const double EvaluateAt(double x) const;
    const double EvaluateDerivativeAt(double x) const;
};