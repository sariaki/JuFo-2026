from matplotlib.lines import Line2D
from matplotlib.patches import Patch
import math
import numpy as np
np.math = math
import matplotlib.pyplot as plt
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
os.chdir(script_dir)

dataset_colors = ['#9671bd', '#7e7e7e', '#77b5b6'] 
dataset_line_colors = ['#6a408d', '#4e4e4e', '#378d94']
regression_color = '#8a8a8a'
marker_colors = ['#b25ef7']

a = 1 # np.random.rand()
k = 0 # np.random.randint(0, 10)

xs = np.linspace(k, k + 1/a, 100)

def eval_bernstein(coeffs, xs):
    # Map to normalized [0; 1]
    xs_norm = np.asarray(xs)
    xs_norm -= k
    xs_norm *= a
    n = len(coeffs) - 1

    # Compute Bernstein polynomial
    binom = np.array([np.math.comb(n, k) for k in range(n+1)])[:, None]
    x_pow = np.array([xs_norm**k for k in range(n+1)])
    one_minus = np.array([(1.0 - xs_norm)**(n - k) for k in range(n+1)])
    terms = (coeffs[:, None] * binom) * x_pow * one_minus
    
    return terms.sum(axis=0)

def get_coeffs_from_dirichlet(n, alpha=0.2):
    # smaller alpha -> spikier / fewer big jumps.
    # rng = np.random.default_rng()
    rng = np.random.default_rng(0)

    if n < 1:
        return np.array([0.0, 1.0])
    
    pieces = rng.dirichlet(np.ones(n) * alpha)  # length n
    coeffs = np.concatenate(([0.0], np.cumsum(pieces)[:-1], [1.0]))
    return coeffs

# Plot
def plot_cdf_inv(ax):
    ax.set_xlabel(f"$x$")
    ax.set_ylabel(f"$y=B_n(x)$")

    ax.set_aspect('equal', adjustable='datalim') # Lock the square shape

    # Major grid:
    ax.grid(True, which='major', linestyle='-', linewidth=0.75, alpha=0.25)

    # Minor ticks and grid:
    ax.minorticks_on()
    ax.grid(True, which='minor', linestyle='-', linewidth=0.25, alpha=0.15)

    ax.set_axisbelow(True) # Ensure grid is below data

    # Create random Bernstein coefficient satisfying CDF requirements and plot
    degree = 10 #np.random.randint(3, 10)
    coeffs = get_coeffs_from_dirichlet(degree, alpha=0.1)
    ys = eval_bernstein(coeffs, xs)

    ax.plot(xs, ys, linewidth=1.2, color = dataset_line_colors[2])

    # Add some x and y-values and mark them
    # plt.xticks(list(plt.xticks()[0]) + [0.3])
    # print(eval_bernstein(coeffs, [0.3]))
    # plt.yticks(list(plt.yticks()[0]) + eval_bernstein(coeffs, [0.3]))
    ax.get_xticklabels()[1].set_color(marker_colors[0])
    ax.get_yticklabels()[1].set_color(marker_colors[0])

    handles, labels = ax.get_legend_handles_labels() # get all legend items
    labels = ["Bernsteinpolynome"] + labels

    ax.legend(
        handles,
        labels,
        loc='upper center',
        bbox_to_anchor=(0.5, 1.10),
        ncol=4,
        frameon=False,
        fontsize='large'
    )

    plt.savefig("output/bernstein.pdf")
    plt.show()

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

plot_cdf_inv(ax)
# ax.plot(xs, ys, linewidth = 2.6, color = dataset_line_colors[2])
# ax.plot(xs, ys_poly_pred, linewidth = 2.6, color = regression_color, linestyle='--')