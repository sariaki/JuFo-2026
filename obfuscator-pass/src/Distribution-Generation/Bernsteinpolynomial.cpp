#include "Bernsteinpolynomial.hpp"

double MonotonicBernstein::BensteinBasisPolynomial(double x, int i, int n) const
{
    return Utils::BinomialCoefficient(n, i) * std::pow(x, i) * std::pow(1.0 - x, n - i);
}

double MonotonicBernstein::BensteinBasisPolynomialDerivative(double x, int i, int n) const
{
    // b_{v, n} = Binom(n-1, i) * x^i * (1-x)^(n-1-i)
    return Utils::BinomialCoefficient(n - 1, i) * std::pow(x, i) * std::pow(1.0 - x, n - 1 - i);
}

MonotonicBernstein::MonotonicBernstein(uint64_t Degree, std::mt19937 Rng, double HorizontalStretch, double HorizontalShift)
    : m_Degree(Degree), m_Rng(Rng), m_HorizontalStretch(HorizontalStretch), m_HorizontalShift(HorizontalShift)
{
    m_Coefficients.reserve(m_Degree + 1);
    m_DerivativeCoefficients.reserve(m_Degree);
}

// We use the Dirichlet distribution to get the bell shape
const std::vector<double>& MonotonicBernstein::GetRandomCoefficients()
{
    m_Coefficients.clear();
    m_DerivativeCoefficients.clear();

    std::gamma_distribution<double> GammaDistribution(0.8, 1.0 );
    std::uniform_real_distribution<double> TinyShift(0.0, 1e-12); // For numerical safety

    if (m_Degree < 1)
    {
        m_Coefficients.push_back(0.0);
        m_Coefficients.push_back(1.0);
        return m_Coefficients;
    }

    // Sample n numbers from Gamma distribution
    std::vector<double> Gammas;
    Gammas.reserve(m_Degree);
    double Sum = 0.0;
    for (int i = 0; i < m_Degree; ++i)
    {
        double GammaRand = GammaDistribution(m_Rng);
        GammaRand += 1e-12; // Avoid zeros
        Gammas.push_back(GammaRand);
        Sum += GammaRand;
    }

    // Normalize Sum to 1
    for (double &g : Gammas) 
        g /= Sum; 

    // Calculate sorted coefficients in [0; 1] 
    m_Coefficients.push_back(0.0);

    double Running = 0.0;
    const double Epsilon = 1e-9; // minimum spacing to avoid floats rounding to previous value

    for (int i = 0; i < m_Degree-1; ++i)
    {
        Running += Gammas[i];

        // Ensure strict monotinicity: enforce at least epsilon spacing from previous
        if (Running <= m_Coefficients.back() + Epsilon)
            Running = m_Coefficients.back() + Epsilon;
        if (Running >= 1.0 - Epsilon*(m_Degree-i))
            Running = 1.0 - Epsilon*(m_Degree-i); // Keep room for remaining points
        m_Coefficients.push_back(Running + TinyShift(m_Rng));
    }

    m_Coefficients.push_back(1.0);

    // Compute derivative coefficients for Bernstein: (n) * (c_{i+1} - c_i)
    for (int i = 0; i < m_Degree; ++i)
        m_DerivativeCoefficients.push_back((m_Coefficients[i+1] - m_Coefficients[i]) * static_cast<double>(m_Degree));

    return m_Coefficients;
}

const std::vector<double> &MonotonicBernstein::GetDerivativeCoefficients() const
{
    return m_DerivativeCoefficients;
}

const int MonotonicBernstein::GetDegree() const
{
    return m_Degree;
}

// a
const int MonotonicBernstein::GetHorizontalStretch() const
{
    return m_HorizontalStretch;
}

// k
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
        Result += Coefficient * BensteinBasisPolynomial(m_HorizontalStretch * (x - m_HorizontalShift), i, m_Degree);
    }

    return Result;
}

const double MonotonicBernstein::EvaluateDerivativeAt(double x) const
{
    // B'(x) = n * sum( (C_{i+1}-C_i) * Binom(n-1, i) * x^i * (1-x)^(n-1-i) )
    double Result = 0.0;
    for (int i = 0; i < m_Degree; i++)
    {
        double Coefficient = m_DerivativeCoefficients[i];
        Result += Coefficient * BensteinBasisPolynomialDerivative(m_HorizontalStretch * (x - m_HorizontalShift), i, m_Degree);
    }

    // Apply chain rule
    return Result * m_HorizontalStretch;
}