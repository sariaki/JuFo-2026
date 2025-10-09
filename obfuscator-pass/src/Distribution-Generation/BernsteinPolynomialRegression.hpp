#pragma once
#include <iostream>
#include <vector>
#include <cmath>
#include <nlopt.hpp>
#include <string>

class MonotonicBernsteinNNLS
{
private:
    int m_Degree;
    std::vector<double> m_Coefficients;
    std::vector<double> m_Xs;
    std::vector<double> m_Ys;

    double BinomialCoefficient(int n, int k) const;
    double BensteinBasisPolynomial(double x, int i, int n) const;
    static double ObjectiveFn(const std::vector<double>& Coefficients, std::vector<double>& Gradient, void* Data);

public:
    MonotonicBernsteinNNLS(int Degree);

    bool Fit(const std::vector<double>& Xs, const std::vector<double>& Ys);
    const std::vector<double>& GetCoefficients() const;
    const int GetDegree() const;
};