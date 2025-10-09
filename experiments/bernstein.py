import numpy as np
from scipy.optimize import minimize
from scipy.special import comb
import matplotlib.pyplot as plt

class MonotonicBernsteinFitter:
    def __init__(self, degree):
        self.degree = degree
        self.coefficients = None
    
    def bernstein_basis(self, t, i, n):
        """Compute the i-th Bernstein basis polynomial of degree n at t"""
        return comb(n, i) * (t**i) * ((1-t)**(n-i))
    
    def evaluate(self, t, coefficients=None):
        """Evaluate the Bernstein polynomial at t"""
        if coefficients is None:
            coefficients = self.coefficients
        
        t = np.atleast_1d(t)
        result = np.zeros_like(t)
        
        for i in range(self.degree + 1):
            result += coefficients[i] * self.bernstein_basis(t, i, self.degree)
        
        return result
    
    def fit_constrained(self, t_data, y_data, strict_monotonic=True, epsilon=1e-6):
        """
        Fit Bernstein polynomial with monotonicity and boundedness constraints
        
        Parameters:
        - t_data: input points (should be in [0,1])
        - y_data: output points (should be in [0,1])
        - strict_monotonic: if True, enforces strict monotonicity
        - epsilon: minimum difference between consecutive coefficients for strict monotonicity
        """
        
        def objective(coeffs):
            """Least squares objective function"""
            y_pred = self.evaluate(t_data, coeffs)
            return np.sum((y_data - y_pred)**2)
        
        # Initial guess: linear interpolation between 0 and 1
        initial_coeffs = np.linspace(0, 1, self.degree + 1)
        
        # Constraints
        constraints = []
        
        # Boundedness constraints: 0 ≤ c_i ≤ 1
        bounds = [(0, 1) for _ in range(self.degree + 1)]
        
        # Monotonicity constraints
        if strict_monotonic:
            # Strict monotonicity: c_i + epsilon ≤ c_{i+1}
            for i in range(self.degree):
                constraints.append({
                    'type': 'ineq',
                    'fun': lambda coeffs, i=i: coeffs[i+1] - coeffs[i] - epsilon
                })
        else:
            # Non-strict monotonicity: c_i ≤ c_{i+1}
            for i in range(self.degree):
                constraints.append({
                    'type': 'ineq',
                    'fun': lambda coeffs, i=i: coeffs[i+1] - coeffs[i]
                })
        
        # Solve the constrained optimization problem
        result = minimize(
            objective,
            initial_coeffs,
            method='SLSQP',
            bounds=bounds,
            constraints=constraints,
            options={'ftol': 1e-9, 'disp': False}
        )
        
        if result.success:
            self.coefficients = result.x
            return result
        else:
            raise RuntimeError(f"Optimization failed: {result.message}")
    
    def fit_with_endpoint_constraints(self, t_data, y_data, start_value=None, end_value=None):
        """
        Fit with additional endpoint constraints
        
        Parameters:
        - start_value: if provided, forces B(0) = start_value
        - end_value: if provided, forces B(1) = end_value
        """
        
        def objective(coeffs):
            y_pred = self.evaluate(t_data, coeffs)
            return np.sum((y_data - y_pred)**2)
        
        initial_coeffs = np.linspace(start_value or 0, end_value or 1, self.degree + 1)
        
        constraints = []
        bounds = [(0, 1) for _ in range(self.degree + 1)]
        
        # Endpoint constraints
        if start_value is not None:
            constraints.append({
                'type': 'eq',
                'fun': lambda coeffs: coeffs[0] - start_value
            })
            bounds[0] = (start_value, start_value)
        
        if end_value is not None:
            constraints.append({
                'type': 'eq',
                'fun': lambda coeffs: coeffs[-1] - end_value
            })
            bounds[-1] = (end_value, end_value)
        
        # Strict monotonicity
        epsilon = 1e-6
        for i in range(self.degree):
            constraints.append({
                'type': 'ineq',
                'fun': lambda coeffs, i=i: coeffs[i+1] - coeffs[i] - epsilon
            })
        
        result = minimize(
            objective,
            initial_coeffs,
            method='SLSQP',
            bounds=bounds,
            constraints=constraints,
            options={'ftol': 1e-9}
        )
        
        if result.success:
            self.coefficients = result.x
            return result
        else:
            raise RuntimeError(f"Optimization failed: {result.message}")

# Example usage and demonstration
def demonstrate_fitting():
    # Generate some sample data
    np.random.seed(42)
    t_sample = np.linspace(0, 1, 10)
    y_true = 0.2 + 0.6 * t_sample**2  # Some monotonic function
    y_noisy = y_true + 0.05 * np.random.randn(len(t_sample))
    y_noisy = np.clip(y_noisy, 0, 1)  # Ensure it's in [0,1]
    
    # Fit Bernstein polynomial
    degree = 5
    fitter = MonotonicBernsteinFitter(degree)
    
    try:
        result = fitter.fit_constrained(t_sample, y_noisy, strict_monotonic=True)
        print(f"Optimization successful!")
        print(f"Bernstein coefficients: {fitter.coefficients}")
        print(f"Final objective value: {result.fun:.6f}")
        
        # Evaluate on fine grid for plotting
        t_fine = np.linspace(0, 1, 100)
        y_fitted = fitter.evaluate(t_fine)
        
        # Plot results
        plt.figure(figsize=(10, 6))
        plt.scatter(t_sample, y_noisy, color='red', label='Data points', zorder=3)
        plt.plot(t_fine, y_fitted, 'b-', linewidth=2, label=f'Bernstein fit (degree {degree})')
        plt.plot(t_sample, y_true, 'g--', alpha=0.7, label='True function')
        plt.xlabel('t')
        plt.ylabel('y')
        plt.title('Monotonic Bernstein Polynomial Fit')
        plt.legend()
        plt.grid(True, alpha=0.3)
        plt.xlim(0, 1)
        plt.ylim(0, 1)
        plt.show()
        
        # Verify monotonicity
        derivatives = np.diff(y_fitted)
        print(f"Monotonicity check: all derivatives > 0? {np.all(derivatives > 0)}")
        print(f"Min derivative: {np.min(derivatives):.6f}")
        
    except RuntimeError as e:
        print(f"Fitting failed: {e}")

# Additional utility function
def fit_bernstein_to_data(t_data, y_data, degree=5, strict_monotonic=True):
    """
    Convenience function to fit a monotonic Bernstein polynomial
    
    Parameters:
    - t_data: input points in [0,1]
    - y_data: output points in [0,1]
    - degree: degree of Bernstein polynomial
    - strict_monotonic: whether to enforce strict monotonicity
    
    Returns:
    - fitter: fitted MonotonicBernsteinFitter object
    - coefficients: Bernstein coefficients
    """
    fitter = MonotonicBernsteinFitter(degree)
    result = fitter.fit_constrained(t_data, y_data, strict_monotonic)
    return fitter, fitter.coefficients

if __name__ == "__main__":
    demonstrate_fitting()