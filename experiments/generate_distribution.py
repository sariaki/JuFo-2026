import numpy as np
import numpy.polynomial.polynomial as poly
from sklearn.linear_model import Ridge
from sklearn.isotonic import IsotonicRegression
from scipy.interpolate import PchipInterpolator
from scipy.stats import binom
import matplotlib.pyplot as plt
from random import uniform

N = 10

# https://alexshtf.github.io/2024/01/21/Bernstein.html
def bernvander(x, deg):
    return binom.pmf(np.arange(1 + deg), deg, x.reshape(-1, 1))

def fit_poly(vandermonde_matrix, n, alpha, xs, ys):
    model = Ridge(fit_intercept=False, alpha=alpha)
    model.fit(vandermonde_matrix(xs, deg=n), ys)
    return model

# Generate features
xs = np.zeros(N+1)
for i in range(N+1):
    xs[i] = i/N

ys = np.zeros(N+1)
for i in range(1, N):
    ys[i] = uniform((i-1)/N, i/N)
ys[0] = 0
ys[N] = 1.0

print(xs)
print(ys)

# Fit models...

# Regular Polynomial
poly_model = fit_poly(poly.polyvander, N, 0, xs, ys)

# PCHIP
pchip_model = PchipInterpolator(xs, ys)

# Bernstein-Polynomial
bern_poly_model = fit_poly(bernvander, N, alpha=1e-2, xs=xs, ys=ys)
# def bernstein(coeffs, xs):
#     xs = np.asarray(xs)
#     n = len(coeffs) - 1
#     binom = np.array([np.math.comb(n, k) for k in range(n+1)])[:, None]
#     x_pow = np.array([xs**k for k in range(n+1)])                      
#     one_minus = np.array([(1.0 - xs)**(n - k) for k in range(n+1)])    
#     terms = (coeffs[:, None] * binom) * x_pow * one_minus              
#     return terms.sum(axis=0)

# bernstein_coeffs = ys.copy()

# Plot
plt_xs = np.linspace(0, 1, 1000)

plt.scatter(xs, ys)
# plt.plot(plt_xs, poly_model.predict(poly.polyvander(plt_xs, deg=N)), color='r', label='Polynom')
# plt.plot(plt_xs, pchip_model(plt_xs), color='g', label='PCHIP')
plt.plot(plt_xs, bern_poly_model.predict(bernvander(plt_xs, deg=N)), color='purple', label='Bernstein-Polynom')
# plt.plot(plt_xs, bernstein(bernstein_coeffs, plt_xs), color='purple', label='Bernstein-Polynom')

for x in np.linspace(0, 1, N):
    plt.axvline(x, color='gray', linestyle='dotted')
    plt.axhline(x, color='gray', linestyle='dotted')

plt.ylim(-0.05, 1.05)
plt.xlim(-0.05, 1.05)
plt.show()