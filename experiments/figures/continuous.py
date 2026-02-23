import math
import numpy as np
np.math = math
from scipy.interpolate import BPoly, PPoly
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import os

if not os.path.exists("output"):
    os.makedirs("output")

dataset_colors = ['#9671bd', '#7e7e7e', '#77b5b6'] 
dataset_line_colors = ['#6a408d', '#4e4e4e', '#378d94']

# Setup parameters
a = 1 
k = 0 
xs = np.linspace(k, k + 1/a, 200)

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

def get_pdf_values(cdf_coeffs, xs):
    n = len(cdf_coeffs) - 1
    # New coefficients for degree n-1
    diffs = cdf_coeffs[1:] - cdf_coeffs[:-1]
    pdf_coeffs = diffs * n * a 
    return eval_bernstein(pdf_coeffs, xs)

def inv_berinstein(y_targets, coeffs):
    if np.isscalar(y_targets):
        y_targets = [y_targets]
        
    x_roots = []
    
    for y in y_targets:
        shifted_coeffs = coeffs - y
        bp = BPoly(shifted_coeffs[:, None], [0, 1])
        pp = PPoly.from_bernstein_basis(bp)
        roots = pp.roots()
        valid_roots = roots[(roots >= -1e-8) & (roots <= 1.0 + 1e-8)]
        
        if len(valid_roots) > 0:
            t = valid_roots[0]
            x_roots.append(t / a + k)
        else:
            x_roots.append(np.nan)

    return np.array(x_roots)

def get_coeffs_from_dirichlet(n, alpha=0.1):
    rng = np.random.default_rng()

    if n < 1:
        return np.array([0.0, 1.0])
    
    pieces = rng.dirichlet(np.ones(n) * alpha) 
    coeffs = np.concatenate(([0.0], np.cumsum(pieces)[:-1], [1.0]))
    return coeffs

def plot_pdf_with_interval(ax):
    ax.set_xlabel(r"$x$")
    ax.set_ylabel(r"Wahrscheinlichkeitsdichte $P(x)$")

    # Major grid:
    ax.grid(True, which='major', linestyle='-', linewidth=0.75, alpha=0.25)
    # Minor ticks and grid:
    ax.minorticks_on()
    ax.grid(True, which='minor', linestyle='-', linewidth=0.25, alpha=0.15)
    ax.set_axisbelow(True)

    degree = 12 
    cdf_coeffs = get_coeffs_from_dirichlet(degree)
    
    # Get PDF values
    ys_pdf = get_pdf_values(cdf_coeffs, xs)
    
    # Calculate 99% Interval bounds
    p_low = 0.01
    p_high = 0.99
    
    x_bounds = inv_berinstein([p_low, p_high], cdf_coeffs)
    x_low, x_high = x_bounds[0], x_bounds[1]
    
    # Plot PDF curve
    curve, = ax.plot(xs, ys_pdf, linewidth=2.5, color=dataset_line_colors[2], zorder=5)
    curve.set_label("P(x)")

    # Fill the Interval
    # Create mask for area between bounds
    mask = (xs >= x_low) & (xs <= x_high)
    ax.fill_between(xs, ys_pdf, 0, where=mask, 
                    color=dataset_colors[2], alpha=0.3, 
                    label="99%-Intervall")
    
    # Mark boundaries
    y_low = get_pdf_values(cdf_coeffs, [x_low])[0]
    y_high = get_pdf_values(cdf_coeffs, [x_high])[0]

    # Vertical dashed lines for bounds
    ax.vlines(x_low, 0, y_low, color=dataset_line_colors[0], linestyle='--', linewidth=1.5, alpha=0.8)
    ax.vlines(x_high, 0, y_high, color=dataset_line_colors[0], linestyle='--', linewidth=1.5, alpha=0.8)

    # Add points at boundary intersection
    ax.scatter([x_low, x_high], [y_low, y_high], s=75, color=dataset_line_colors[0], 
               edgecolor='white', linewidth=1.5, zorder=10)

    # Add an arrow showing bound
    mid_y = max(ys_pdf) * 0.4
    ax.annotate(
        '', xy=(x_low, mid_y), xytext=(x_high, mid_y),
        arrowprops=dict(arrowstyle='<->', color=dataset_line_colors[1], linewidth=1.5)
    )
    ax.text((x_low + x_high)/2, mid_y + 0.05, "99%-Intervall", 
            ha='center', va='bottom', color=dataset_line_colors[1], weight='bold')

    current_ticks = list(ax.get_xticks())
    # Filter ticks that are too close to our special bounds to avoid clutter
    current_ticks = [t for t in current_ticks if abs(t - x_low) > 0.05 and abs(t - x_high) > 0.05 and 0 <= t <= 1]
    
    final_ticks = sorted(current_ticks + [x_low, x_high])
    ax.set_xticks(final_ticks)
    
    labels = []
    for t in final_ticks:
        if abs(t - x_low) < 1e-4 or abs(t - x_high) < 1e-4:
            labels.append(f"{t:.3f}") # More precision for bounds
        else:
            labels.append(f"{t:.1f}")
            
    ax.set_xticklabels(labels)
    
    # Highlight bound labels colors
    for tick in ax.xaxis.get_major_ticks():
        try:
            val = tick.get_loc()
            if abs(val - x_low) < 1e-4 or abs(val - x_high) < 1e-4:
                tick.label1.set_color(dataset_line_colors[0])
                tick.label1.set_fontweight('bold')
        except:
            pass

    ax.tick_params(axis='x', rotation=315)
    plt.setp(ax.get_xticklabels(), rotation=315, ha='left', rotation_mode='anchor')

    # Legend
    handles, labels = ax.get_legend_handles_labels()
    ax.legend(
        handles,
        labels,
        loc='upper center',
        bbox_to_anchor=(0.5, 1.15),
        ncol=2,
        frameon=False,
        fontsize='large'
    )

    # Adjust limits to look nice
    ax.set_xlim(0, 1)
    ax.set_ylim(bottom=0)

    plt.tight_layout()
    plt.savefig("output/pdf.svg")
    plt.show()

# Global Font Settings
plt.rcParams.update({
    'font.family': 'serif', 
    'font.size': 20,
    'axes.titlesize': 20,
    'axes.labelsize': 20,
    'xtick.labelsize': 20,
    'ytick.labelsize': 20,
    'legend.fontsize': 20,
    'figure.titlesize': 20
})

fig, ax = plt.subplots(figsize=(10, 8)) # Slightly rectangular is better for PDFs usually
plot_pdf_with_interval(ax)