import math
import numpy as np
np.math = math
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
os.chdir(script_dir)

dataset_colors = ['#9671bd', '#7e7e7e', '#77b5b6'] 
dataset_line_colors = ['#6a408d', '#4e4e4e', '#378d94']

tick_count = 11
cmap = plt.get_cmap('hsv') 
indices = np.linspace(0.0, 1.0, tick_count) 
tick_colors = [cmap(i) for i in indices]

a = 1
k = 0

xs = np.linspace(k, k + 1/a, 100)

def eval_exponential(lambda_, xs):
    xs = np.asarray(xs)
    L = 1.0 / a

    if lambda_ == 0:
        # Uniform: linear mapping from [k, k+L] -> [0,1]
        t = (xs - k) / L
        return np.clip(t, 0.0, 1.0)

    # Numeric safe
    lam = float(lambda_)
    denom = 1.0 - np.exp(-lam * L)
    # For numerical stability if denom is extremely small, treat as almost uniform.
    if denom < 1e-12:
        t = (xs - k) / L
        return np.clip(t, 0.0, 1.0)

    t = xs - k
    # Ensure non-negative inside exp
    t = np.maximum(t, 0.0)
    numer = 1.0 - np.exp(-lam * t)
    return np.clip(numer / denom, 0.0, 1.0)

def inv_exponential(y_targets, lambda_):
    L = 1.0 / a
    lam = float(lambda_)

    # Convert to array (keeps shape)
    y = np.atleast_1d(y_targets).astype(float)
    y = np.clip(y, 0.0, 1.0)

    # Uniform special-case
    if np.isclose(lam, 0.0):
        out = k + y * L
        return out

    denom_factor = 1.0 - np.exp(-lam * L)

    # Avoid negative/zero inside log
    inner = 1.0 - y * denom_factor
    inner = np.clip(inner, 1e-16, 1.0)

    t = - (1.0 / lam) * np.log(inner)
    x = k + t
    x = np.clip(x, k, k + L)
    return x

# Plot
def plot_cdf_inv(ax):
    ax.set_xlabel(r"$x = F^{-1}(y)$")
    ax.set_ylabel(r"$y=F(x)$")

    ax.set_aspect('equal', adjustable='datalim') # Lock the square shape
    ax.grid(True, which='major', linestyle='-', linewidth=0.75, alpha=0.25)
    ax.minorticks_on()
    ax.grid(True, which='minor', linestyle='-', linewidth=0.25, alpha=0.15)
    ax.set_axisbelow(True)

    # Choose an exponential rate lambda_. Try a few example values:
    lambda_ = 3.0  # change this to make distribution more/less concentrated near k

    ys = eval_exponential(lambda_, xs)

    curve, = ax.plot(xs, ys, linewidth=1.2, color = dataset_line_colors[2])
    curve.set_label(f"Exponentialverteilung CDF")

    # Add some x and y-values
    yticks = np.linspace(0.0, 1.0, tick_count)
    xticks = inv_exponential(yticks, lambda_)
    ax.set_xticks(xticks)
    ax.set_yticks(yticks)

    # Set formatted text labels
    labels = [f"{val:.2f}" for val in xticks]
    ax.set_xticklabels(labels)
    labels = [f"{val:.1f}" for val in yticks]
    ax.set_yticklabels(labels)

    ax.tick_params(axis='x', rotation=270)
    plt.setp(ax.get_xticklabels(), rotation=270, ha='left')

    # Add dashed arrow from curve to tick
    for i, tick in enumerate(ax.xaxis.get_major_ticks()):
        ax.annotate('', xy=(xticks[i], yticks[i]), xytext=(xticks[i], 0),
                    arrowprops=dict(arrowstyle='<-', linestyle='--', color=dataset_line_colors[0], alpha=0.6))

    # Add dashed line from tick to curve
    for i, tick in enumerate(ax.yaxis.get_major_ticks()):
        y_val = tick.get_loc()
        x_val = inv_exponential(y_val, lambda_)[0]
        ax.plot([k, x_val], [y_val, y_val], color=dataset_line_colors[0], linewidth=1.0, linestyle='--', alpha=0.6)

    ax.scatter(
        xticks,
        yticks,
        s=75,
        c=dataset_line_colors[0],
        marker='o',
        edgecolor='white',
        linewidth=1.5,
        zorder=10
    )

    handles, labels = ax.get_legend_handles_labels()
    ax.legend(
        handles,
        labels,
        loc='upper center',
        bbox_to_anchor=(0.5, 1.10),
        ncol=4,
        frameon=False,
        fontsize='large'
    )

    plt.savefig("output/cdf_inv_exp.pdf")
    plt.show()

plt.rcParams.update({
    'font.family': 'serif', # Courier New
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