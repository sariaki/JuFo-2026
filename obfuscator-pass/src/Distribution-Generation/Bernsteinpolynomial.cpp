#include "Bernsteinpolynomial.hpp"

double MonotonicBernstein::BensteinBasisPolynomial(double x, int i, int n) const
{
    return Utils::BinomialCoefficient(n, i) * std::pow(x, i) * std::pow(1.0 - x, n - i);
}

MonotonicBernstein::MonotonicBernstein(uint64_t Degree, std::mt19937 Rng, double VerticalStretch, double HorizontalShift)
    : m_Degree(Degree), m_Rng(Rng), m_VerticalStretch(VerticalStretch), m_HorizontalShift(HorizontalShift)
{
    m_Coefficients.resize(m_Degree + 1);
}

const std::vector<double>& MonotonicBernstein::GetRandomCoefficients()
{
    // Guarantee that the polynomial goes through (0|0) && (0|1)
    m_Coefficients[0] = 0.0;
    m_Coefficients[m_Degree] = 1.0;

    // Generate coefficients randomly, 
    // guaranteeing that the polynomial is monotonically increasing:
    // c_0 <= c_1 <= ... <= c_n
    for (int i = 1; i < m_Degree; i++)
    {
        m_Coefficients[i] = m_Coefficients[i - 1] + std::uniform_real_distribution(0.0, 
            1.0 / static_cast<double>(m_Degree))(m_Rng);
        errs() << "m_Coefficients[i]: " << m_Coefficients[i] << "\n";
    }

    return m_Coefficients;
}

const int MonotonicBernstein::GetDegree() const
{
    return m_Degree;
}

const int MonotonicBernstein::GetVerticalStretch() const
{
    return m_VerticalStretch;
}

const int MonotonicBernstein::GetHorizontalShift() const
{
    return m_HorizontalShift;
}

const double MonotonicBernstein::EvaluateAt(double x) const
{
    double Result = 0.0;
    for (int i = 0; i <= m_Degree; i++)
    {
        double Coefficient = m_Coefficients[i];
        Result += Coefficient * BensteinBasisPolynomial(m_VerticalStretch * (x - m_HorizontalShift), i, m_Degree);
    }

    return Result;
}
