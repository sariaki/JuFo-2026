import numpy as np
import matplotlib.pyplot as plt
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
os.chdir(script_dir)

a = np.random.rand()
k = np.random.randint(0, 10)

xs = np.linspace(k, k + 1/a, 100)

def eval_bernstein(coeffs, xs):
    xs_norm = np.asarray(xs)
    xs_norm -= k
    xs_norm *= a
    n = len(coeffs) - 1

    binom = np.array([np.math.comb(n, k) for k in range(n+1)])[:, None]
    x_pow = np.array([xs_norm**k for k in range(n+1)])
    one_minus = np.array([(1.0 - xs_norm)**(n - k) for k in range(n+1)])
    terms = (coeffs[:, None] * binom) * x_pow * one_minus
    
    return terms.sum(axis=0)

# Create random Bernstein coefficients satisfying CDF requirements
degree = 10
coeffs = np.random.rand(degree-2) # in [0; 1]
coeffs.sort()
coeffs = np.insert(coeffs, 0, 0)
coeffs = np.append(coeffs, 1.0)

ys = eval_bernstein(coeffs, xs)

# Try generating a regular polynomial with the same method (random coefficients)
poly_coeffs = np.random.rand(degree) # in [0; 1]
ys_poly_pred = np.polyval(poly_coeffs, xs)

print(poly_coeffs)

# Plot
plt.rcParams.update({
    'font.family': 'Courier New',  # monospace font
    'font.size': 20,
    'axes.titlesize': 20,
    'axes.labelsize': 20,
    'xtick.labelsize': 20,
    'ytick.labelsize': 20,
    'legend.fontsize': 20,
    'figure.titlesize': 20
})

fig, ax = plt.subplots(figsize=(10, 10))

ax.set_xlabel(f"x")
ax.set_ylabel(f"$y=B_n(x)$")

ax.set_aspect('equal', adjustable='datalim') # Lock the square shape

# Major grid:
ax.grid(True, which='major', linestyle='-', linewidth=0.75, alpha=0.25)

# Minor ticks and grid:
ax.minorticks_on()
ax.grid(True, which='minor', linestyle='-', linewidth=0.25, alpha=0.15)

ax.set_axisbelow(True) # Ensure grid is below data

dataset_colors = ['#9671bd', '#7e7e7e', '#77b5b6'] 
dataset_line_colors = ['#6a408d', '#4e4e4e', '#378d94']
regression_color = '#8a8a8a' # <-- neutral grey

ax.plot(xs, ys, linewidth = 2.6, color = dataset_line_colors[2])
ax.plot(xs, ys_poly_pred, linewidth = 2.6, color = regression_color, linestyle='--')

plt.show()