import math
import numpy as np
np.math = math
from scipy.interpolate import BPoly, PPoly
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
os.chdir(script_dir)

dataset_colors = ['#9671bd', '#7e7e7e', '#77b5b6'] 
dataset_line_colors = ['#6a408d', '#4e4e4e', '#378d94']
cmap = plt.get_cmap('viridis') 
indices = np.linspace(0.1, 0.75, 10) # Sample from 0.3 to 0.9 to avoid colors that are too bright/dark
tick_colors = [cmap(i) for i in indices]

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

def inv_berinstein(y_targets, coeffs):
    # Ensure input is iterable (if a single float is passed)
    if np.isscalar(y_targets):
        y_targets = [y_targets]
        
    x_roots = []
    
    for y in y_targets:
        # Shift coefficients: P(t) - y = 0
        shifted_coeffs = coeffs - y
        
        # Create BPoly for y
        # Shape must be (n, 1) because we have 1 interval [0, 1]
        bp = BPoly(shifted_coeffs[:, None], [0, 1])
        
        # Convert to PPoly (Power basis) to access .roots()
        pp = PPoly.from_bernstein_basis(bp)
        roots = pp.roots()
        
        # Filter for roots in [0, 1]
        valid_roots = roots[(roots >= -1e-8) & (roots <= 1.0 + 1e-8)]
        
        if len(valid_roots) > 0:
            # Take the first valid root found
            t = valid_roots[0]
            x_roots.append(t / a + k)
        else:
            x_roots.append(np.nan)

    return np.array(x_roots)

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

    # Add some x and y-values
    tick_count = 10
    yticks = np.linspace(0.0, 1.0, tick_count)
    xticks = inv_berinstein(yticks, coeffs)
    ax.set_xticks(xticks)
    ax.set_yticks(yticks)

    # Set formatted text labels (2 decimal places)
    labels = [f"{val:.2f}" for val in xticks]
    ax.set_xticklabels(labels)
    labels = [f"{val:.2f}" for val in yticks]
    ax.set_yticklabels(labels)

    ax.tick_params(axis='x', rotation=315)
    plt.setp(ax.get_xticklabels(), rotation=315, ha='left', rotation_mode='anchor')

    # Color ticks
    for i, tick in enumerate(ax.xaxis.get_major_ticks()):
        c = tick_colors[i % len(tick_colors)]
        # label on bottom (label1) and top (label2) if present
        tick.label1.set_color(c)
        tick.label2.set_color(c)
        # the tick mark lines (tick1line, tick2line)
        tick.tick1line.set_color(c)
        tick.tick2line.set_color(c)

    for i, tick in enumerate(ax.yaxis.get_major_ticks()):
        c = tick_colors[i % len(tick_colors)]
        tick.label1.set_color(c)
        tick.label2.set_color(c)
        tick.tick1line.set_color(c)
        tick.tick2line.set_color(c)
    
    ax.scatter(
        xticks,
        yticks,
        s=50,
        c=tick_colors,
        marker='o',
        edgecolor='white',
        linewidth=1.5,
        zorder=10
    )

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

    plt.savefig("output/cdf_inv.pdf")
    plt.show()

plt.rcParams.update({
    'font.family': 'Courier New',  # monospace font
    'font.size': 20,
    'axes.titlesize': 20,
    'axes.labelsize': 20,
    'xtick.labelsize': 16,
    'ytick.labelsize': 20,
    'legend.fontsize': 20,
    'figure.titlesize': 20
})

fig, ax = plt.subplots(figsize=(10, 10))

plot_cdf_inv(ax)
# ax.plot(xs, ys, linewidth = 2.6, color = dataset_line_colors[2])
# ax.plot(xs, ys_poly_pred, linewidth = 2.6, color = regression_color, linestyle='--')