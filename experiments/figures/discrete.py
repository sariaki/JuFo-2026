import numpy as np
import matplotlib.pyplot as plt
import os

if not os.path.exists("output"):
    os.makedirs("output")

dataset_colors = ['#9671bd', '#7e7e7e', '#77b5b6'] 
dataset_line_colors = ['#6a408d', '#4e4e4e', '#378d94']

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

def plot_diskret_deutsch(ax):
    x_pos = np.array([1, 2, 3, 4, 5])
    wahrscheinlichkeiten = np.array([0.005, 0.005, 0.99, 0.005, 0.005])
    
    ax.set_xlabel(r"Mögliche Werte")
    ax.set_ylabel(r"Wahrscheinlichkeit $P(x)$")
    
    # Grid and colors
    ax.grid(True, which='major', axis='y', linestyle='-', linewidth=0.75, alpha=0.25)
    ax.set_axisbelow(True)

    balken_farben = [dataset_colors[2]] * 5
    balken_farben[2] = dataset_colors[0] # Main bar in a different color
    
    # Bars
    bars = ax.bar(x_pos, wahrscheinlichkeiten, color=balken_farben, 
                  edgecolor=dataset_line_colors[2], linewidth=1.5, width=0.6, zorder=5)
    
    # Accentuate the main bar with a thicker edge
    bars[2].set_edgecolor(dataset_line_colors[0])
    bars[2].set_linewidth(2.0)

    # Annotation for the main bar (99%)
    target_bar = bars[2]
    height = target_bar.get_height()
    
    ax.text(target_bar.get_x() + target_bar.get_width()/2, height + 0.01, 
            "99%", 
            ha='center', va='bottom', 
            color=dataset_line_colors[0], 
            fontweight='bold', 
            fontsize=24)

    # x-Axis ticks and labels
    labels = ["Wert A", "Wert B", "Zielwert", "Wert D", "Wert E"]
    ax.set_xticks(x_pos)
    ax.set_xticklabels(labels)
    
    # Rotate x-tick labels and set alignment
    ax.tick_params(axis='x', rotation=315)
    plt.setp(ax.get_xticklabels(), rotation=315, ha='left', rotation_mode='anchor')

    # Accentuate the 99% tick label
    ax.xaxis.get_major_ticks()[2].label1.set_color(dataset_line_colors[0])
    ax.xaxis.get_major_ticks()[2].label1.set_fontweight('bold')

    # y-Axis ticks and labels
    ax.set_ylim(0, 1.1)
    ax.set_yticks([0, 0.25, 0.50, 0.75, 1.0])
    ax.set_yticklabels(["0", "0.25", "0.50", "0.75", "1.0"])

    # Annotate noise
    small_bar = bars[4]
    ax.annotate('Rauschen (<1%)', 
                xy=(small_bar.get_x() + small_bar.get_width()/2, small_bar.get_height()), 
                xytext=(small_bar.get_x() - 0.5, 0.20),
                arrowprops=dict(arrowstyle='->', color=dataset_line_colors[1], linewidth=1.5),
                color=dataset_line_colors[1], fontsize=16, ha='center')

# Plot
fig, ax = plt.subplots(figsize=(10, 8))
plot_diskret_deutsch(ax)

plt.tight_layout()
plt.savefig("output/discrete.svg")
plt.show()