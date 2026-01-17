import math
import numpy as np
np.math = math
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import os

# Setup Environment
script_dir = os.path.dirname(os.path.abspath(__file__))
try:
    os.chdir(script_dir)
except FileNotFoundError:
    pass # Fallback, falls z.B. interaktiv ausgeführt

# Output Ordner erstellen, falls nicht vorhanden
if not os.path.exists("output"):
    os.makedirs("output")

# --- Design & Colors (from Template) ---
dataset_colors = ['#9671bd', '#7e7e7e', '#77b5b6'] 
dataset_line_colors = ['#6a408d', '#4e4e4e', '#378d94']

tick_count = 11
cmap = plt.get_cmap('hsv') 
indices = np.linspace(0.0, 1.0, tick_count) 
tick_colors = [cmap(i) for i in indices]

# --- Mathematical Setup for Normal Distribution ---
# Ziel: Peak bei 0.99
# Formel für Peak-Höhe (bei x=0): 1 / (sigma * sqrt(2*pi)) = 0.99
target_peak = 0.99
sigma = 1.0 / (target_peak * np.sqrt(2 * np.pi))
mu = 0.0

# Plot Range (x-Achse)
x_range = 1.2 # Bereich von -1.2 bis +1.2 für schöne Optik
xs = np.linspace(-x_range, x_range, 500)

def eval_normal_pdf(xs, mu, sigma):
    """Berechnet die Wahrscheinlichkeitsdichte (PDF)"""
    xs = np.asarray(xs)
    coeff = 1.0 / (sigma * np.sqrt(2 * np.pi))
    exponent = -0.5 * ((xs - mu) / sigma) ** 2
    return coeff * np.exp(exponent)

def inv_normal_pdf_positive(y_targets, mu, sigma):
    """
    Berechnet x für ein gegebenes y auf der positiven Seite der Glockenkurve.
    (Inverse der PDF ist nicht eindeutig, wir nehmen x >= mu)
    """
    y = np.atleast_1d(y_targets).astype(float)
    max_y = 1.0 / (sigma * np.sqrt(2 * np.pi))
    
    # Clip y um mathematische Fehler bei log(<=0) oder y > peak zu vermeiden
    y = np.clip(y, 1e-10, max_y - 1e-16)
    
    # Umstellung der Gauß-Formel nach x
    # y = A * exp(-0.5 * ((x-mu)/sig)^2)
    # ln(y/A) = -0.5 * ((x-mu)/sig)^2
    # -2 * ln(y/A) = ((x-mu)/sig)^2
    # x = mu + sig * sqrt(-2 * ln(y/A))
    
    term = -2.0 * np.log(y / max_y)
    term = np.maximum(term, 0.0) # Floating point safety
    x = mu + sigma * np.sqrt(term)
    return x

# --- Plot Function ---
def plot_normal_pdf(ax):
    ax.set_xlabel(r"$x$")
    ax.set_ylabel(r"$f(x)$ (Wahrscheinlichkeitsdichte)")

    # Das Template erzwingt ein festes Aspekt-Verhältnis.
    # Da x ca -1.2 bis 1.2 (Breite 2.4) und y 0 bis 1 (Höhe 1) ist,
    # wird das Bild rechteckig. 'equal' behält die Proportionen bei.
    ax.set_aspect('equal', adjustable='datalim') 
    
    ax.grid(True, which='major', linestyle='-', linewidth=0.75, alpha=0.25)
    ax.minorticks_on()
    ax.grid(True, which='minor', linestyle='-', linewidth=0.25, alpha=0.15)
    ax.set_axisbelow(True)

    # Berechne Y-Werte
    ys = eval_normal_pdf(xs, mu, sigma)

    # Plot Curve
    curve, = ax.plot(xs, ys, linewidth=1.5, color=dataset_line_colors[2])
    curve.set_label(f"Normalverteilung PDF")

    # --- Ticks Logic (Reverse Projection style from template) ---
    # Wir definieren Y-Ticks linear und berechnen, wo diese die Kurve schneiden
    # Wir lassen 0.0 aus, da x dort unendlich wäre, und nehmen 0.05 als Start
    yticks = np.linspace(0.05, target_peak, tick_count) 
    
    # Wir berechnen die X-Positionen für die rechte Flanke der Kurve
    xticks_pos = inv_normal_pdf_positive(yticks, mu, sigma)
    
    # Setze Ticks auf den Achsen (wir spiegeln die X-Ticks nicht, um es lesbar zu halten)
    # Optional: Man könnte auch negative Ticks hinzufügen
    ax.set_yticks(yticks)
    ax.set_xticks(np.concatenate([-xticks_pos[::-1], xticks_pos])) # Symmetrische Ticks auf X-Achse

    # Format Labels
    # X-Labels bereinigen (zu viele Labels überlappen sich sonst bei 0)
    x_labels = [f"{val:.2f}" for val in xticks_pos]
    # Spiegele Labels für die Anzeige
    full_x_labels = [f"{-val:.2f}" for val in xticks_pos][::-1] + x_labels
    
    # Nur jeden zweiten Label anzeigen, damit es nicht zu voll wird
    ax.set_xticklabels(full_x_labels)
    
    y_labels = [f"{val:.2f}" for val in yticks]
    ax.set_yticklabels(y_labels)

    ax.tick_params(axis='x', rotation=270)
    plt.setp(ax.get_xticklabels(), rotation=270, ha='left')

    # --- Arrows and Dashed Lines (Template Style) ---
    # Wir zeichnen die Linien nur für die positive Seite (rechts), um das Design des Templates zu wahren
    for i, tick in enumerate(yticks):
        y_val = tick
        x_val = xticks_pos[i]

        # 1. Dashed Line vom Y-Tick zur Kurve
        ax.plot([0, x_val], [y_val, y_val], color=dataset_line_colors[0], linewidth=1.0, linestyle='--', alpha=0.6)
        
        # 2. Dashed Arrow von der Kurve zum X-Tick (nach unten)
        # Im Template war es: Curve -> Axis. Wir machen hier Curve -> X-Axis
        ax.annotate('', xy=(x_val, 0), xytext=(x_val, y_val),
                    arrowprops=dict(arrowstyle='->', linestyle='--', color=dataset_line_colors[0], alpha=0.6))

    # --- Scatter Points on the Curve ---
    ax.scatter(
        xticks_pos,
        yticks,
        s=75,
        c=dataset_line_colors[0],
        marker='o',
        edgecolor='white',
        linewidth=1.5,
        zorder=10
    )
    
    # Optional: Den Peak markieren
    ax.scatter([0], [target_peak], s=75, c=dataset_line_colors[0], marker='o', edgecolor='white', linewidth=1.5, zorder=10)

    # Legende
    handles, labels = ax.get_legend_handles_labels()
    ax.legend(
        handles,
        labels,
        loc='upper center',
        bbox_to_anchor=(0.5, 1.15),
        ncol=4,
        frameon=False,
        fontsize='large'
    )

    # Limits setzen, damit der Plot schön aussieht
    ax.set_xlim(-x_range, x_range)
    ax.set_ylim(0, target_peak + 0.05)

    plt.savefig("output/normal_pdf_hump.pdf", bbox_inches='tight')
    plt.show()

# --- Global Params ---
plt.rcParams.update({
    'font.family': 'serif',
    'font.size': 20,
    'axes.titlesize': 20,
    'axes.labelsize': 20,
    'xtick.labelsize': 16, # Etwas kleiner, da viele Zahlen
    'ytick.labelsize': 20,
    'legend.fontsize': 20,
    'figure.titlesize': 20
})

fig, ax = plt.subplots(figsize=(10, 10))
plot_normal_pdf(ax)