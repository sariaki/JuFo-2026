import numpy as np
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D
from matplotlib.patches import Patch
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
os.chdir(script_dir)

dataset_colors = ['#9671bd', '#7e7e7e', '#77b5b6'] 
dataset_line_colors = ['#6a408d', '#4e4e4e', '#378d94']
regression_color = '#8a8a8a'

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
    rng = np.random.default_rng()

    if n < 1:
        return np.array([0.0, 1.0])
    
    pieces = rng.dirichlet(np.ones(n) * alpha)  # length n
    coeffs = np.concatenate(([0.0], np.cumsum(pieces)[:-1], [1.0]))
    return coeffs

def get_coeffs_from_uniform(n):
    if n < 1:
        return np.array([0.0, 1.0])
    
    coeffs = np.random.rand(n - 2)  # in [0; 1]
    coeffs.sort()
    coeffs = np.insert(coeffs, 0, 0.0)
    coeffs = np.append(coeffs, 1.0)
    return coeffs


# Try generating a regular polynomial with the same method (random coefficients)
# poly_coeffs = np.random.rand(degree) # in [0; 1]
# ys_poly_pred = np.polyval(poly_coeffs, xs)

# Plot
def plot_many_bernsteins(ax, count=200, alpha=0.10):
    ax.set_xlabel(f"$x$")
    ax.set_ylabel(f"$y=B_n(x)$")

    ax.set_aspect('equal', adjustable='datalim') # Lock the square shape

    # Major grid:
    ax.grid(True, which='major', linestyle='-', linewidth=0.75, alpha=0.25)

    # Minor ticks and grid:
    ax.minorticks_on()
    ax.grid(True, which='minor', linestyle='-', linewidth=0.25, alpha=0.15)

    ax.set_axisbelow(True) # Ensure grid is below data

    ys_all = []
    for _ in range(count):
        degree = np.random.randint(3, 10)
        # Create random Bernstein coefficients satisfying CDF requirements and evaluate
        coeffs = get_coeffs_from_dirichlet(degree, alpha=0.1)
        ys = eval_bernstein(coeffs, xs)
        ys_all.append(ys)

    ys_all = np.array(ys_all)
    for ys in range(ys_all.shape[0]):
        ax.plot(xs, ys_all[ys], linewidth=1.2, color = dataset_line_colors[2], alpha=alpha)

    med = np.median(ys_all, axis=0)
    # q05 = np.quantile(ys_all, 0.05, axis=0)
    # q95 = np.quantile(ys_all, 0.95, axis=0)
    # plt.fill_between(xs, q05, q95, color = dataset_colors[1], alpha=0.18, label='5-95% envelope')
    plt.plot(xs, med, color = dataset_colors[0], linewidth=2.0, label='Median')

    bern_proxy = Line2D([0], [0],
                        color=dataset_line_colors[2],
                        linewidth=3.0, alpha=1.0)

    handles, labels = ax.get_legend_handles_labels() # get all legend items

    handles = [bern_proxy] + handles
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
    'font.family': 'serif',  # Courier New
    'font.size': 20,
    'axes.titlesize': 20,
    'axes.labelsize': 20,
    'xtick.labelsize': 20,
    'ytick.labelsize': 20,
    'legend.fontsize': 20,
    'figure.titlesize': 20
})

fig, ax = plt.subplots(figsize=(10, 10))

plot_many_bernsteins(ax, count=300)
# ax.plot(xs, ys, linewidth = 2.6, color = dataset_line_colors[2])
# ax.plot(xs, ys_poly_pred, linewidth = 2.6, color = regression_color, linestyle='--')