#include "BernsteinPolynomialRegression.hpp"

double MonotonicBernsteinNNLS::BinomialCoefficient(int n, int k) const
{
    if (k > n || k < 0) return 0.0;
    if (k == 0 || k == n) return 1.0;

    double Result = 1.0;
    for (int i = 1; i <= k; ++i)
    {
        Result = Result * (n - k + i) / i;
    }
    return Result;
}

double MonotonicBernsteinNNLS::BensteinBasisPolynomial(double x, int i, int n) const
{
    return BinomialCoefficient(n, i) * std::pow(x, i) * std::pow(1.0 - x, n - i);
}

double MonotonicBernsteinNNLS::ObjectiveFn(const std::vector<double>& Coefficients, std::vector<double>& Gradient, void* Data)
{
    MonotonicBernsteinNNLS* Fitter = static_cast<MonotonicBernsteinNNLS*>(Data); // NLopt sadly requires callback vfuncs to take a void*

    double Objective = 0.0;

    // Compute predictions and objective
    for (int i = 0; i < Fitter->m_Xs.size(); i++)
    {
        double PredictedY = 0.0;
        for (int j = 0; j <= Fitter->m_Degree; j++)
        {
            PredictedY += Coefficients[j] * Fitter->BensteinBasisPolynomial(Fitter->m_Xs[j], j, Fitter->m_Degree);
        }
        // MSE
        double DeltaY = Fitter->m_Ys[i] - PredictedY;
        Objective += DeltaY * DeltaY;
    }

    // Compute gradient
    if (!Gradient.empty())
    {
        std::fill(Gradient.begin(), Gradient.end(), 0.0);
        for (int i = 0; i <= Fitter->m_Degree; i++)
        {
            for (int j = 0; j < Fitter->m_Xs.size(); j++)
            {
                // Prediction
                double PreductedY = 0.0;
                for (int k = 0; k <= Fitter->m_Degree; k++)
                {
                    PreductedY += Coefficients[k] * Fitter->BensteinBasisPolynomial(Fitter->m_Xs[j], k, Fitter->m_Degree);
                }

                double DeltaY = Fitter->m_Ys[j] - PreductedY;
                double BasisValue = Fitter->BensteinBasisPolynomial(Fitter->m_Xs[j], i, Fitter->m_Degree);
                Gradient[i] -= 2.0 * DeltaY * BasisValue;
            }
        }
    }

    return Objective;
}

MonotonicBernsteinNNLS::MonotonicBernsteinNNLS(int Degree) : m_Degree(Degree)
{
    m_Coefficients.resize(Degree + 1);
}

bool MonotonicBernsteinNNLS::Fit(const std::vector<double>& Xs, const std::vector<double>& Ys)
{
    m_Xs = Xs;
    m_Ys = Ys;

    nlopt::opt Optimizer(nlopt::LD_SLSQP, m_Degree + 1);
    Optimizer.set_min_objective(ObjectiveFn, this);

    // Bounds [0, 1]
    std::vector<double> LowerBounds(m_Degree + 1, 0.0);
    std::vector<double> UpperBounds(m_Degree + 1, 1.0);
    Optimizer.set_lower_bounds(LowerBounds);
    Optimizer.set_upper_bounds(UpperBounds);

    // Monotonicity constraints
    std::vector<int> ConstraintIndices(m_Degree);
    for (int i = 0; i < m_Degree; ++i)
    {
        ConstraintIndices[i] = i;
        Optimizer.add_inequality_constraint(
            [](const std::vector<double>& x, std::vector<double>& Grad, void* Data) -> double
        {
            int* Idx = static_cast<int*>(Data);
            int i = *Idx;

            if (!Grad.empty())
            {
                std::fill(Grad.begin(), Grad.end(), 0.0);
                Grad[i] = -1.0;
                Grad[i + 1] = 1.0;
            }

            return x[i + 1] - x[i] - 1e-6;
        },
            &ConstraintIndices[i],
            1e-8
        );
    }

    //optimizer.set_xtol_rel(1e-8);
    Optimizer.set_maxeval(100000);

    // Initial guess
    std::vector<double> Coefficients(m_Degree + 1);
    Coefficients[0] = 0.0;
    for (int i = 1; i <= m_Degree; ++i)
    {
        Coefficients[i] = static_cast<double>(i) / m_Degree;
    }

    double MinObjectiveValue;
    Optimizer.set_exceptions_enabled(false);
    nlopt::result Result = Optimizer.optimize(Coefficients, MinObjectiveValue);

    m_Coefficients = Coefficients;

    return (Result == nlopt::SUCCESS || Result == nlopt::FTOL_REACHED || Result == nlopt::XTOL_REACHED);
}

const std::vector<double>& MonotonicBernsteinNNLS::GetCoefficients() const
{
    return m_Coefficients;
}

const int MonotonicBernsteinNNLS::GetDegree() const
{
    return m_Degree;
}