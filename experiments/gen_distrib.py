import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import PchipInterpolator
from scipy.special import erf
from sklearn.isotonic import IsotonicRegression

# Reproduzierbarkeit
np.random.seed(1)

# Knoten (streng monoton steigend, Werte in [0,1])
x_pts = np.linspace(0.0, 1.0, 9)
# saubere CDF-ähnliche Form (erf als glatte CDF-Form)
y_clean = 0.5 * (1.0 + erf((x_pts - 0.4) / 0.12))

# leichtes Rauschen hinzufügen und danach Strikte Monotonie erzwingen
y_noisy = y_clean + 0.02 * np.random.randn(len(y_clean))
y_noisy = np.maximum.accumulate(y_noisy)                # macht monoton nicht-abnehmend
y_noisy = (y_noisy - y_noisy[0]) / (y_noisy[-1] - y_noisy[0])  # normalisiere auf [0,1]

# feines Gitter zum Plotten
x_fine = np.linspace(0.0, 1.0, 400)

# 1) Freie Polynom-Regression (nur zum Vergleich)
poly_deg = 5
poly_coefs = np.polyfit(x_pts, y_noisy, poly_deg)
poly_vals = np.polyval(poly_coefs, x_fine)

# 2) Isotone Regression (garantiert monotone, oft stufig)
iso = IsotonicRegression(out_of_bounds='clip')
iso.fit(x_pts, y_noisy)
iso_vals_fine = iso.predict(x_fine)

# 3) PCHIP (monotone kubische Interpolation, kein Overshoot)
pchip = PchipInterpolator(x_pts, y_noisy)
pchip_vals = pchip(x_fine)

# 4) Bernstein-Polynom (monotone Koeffizienten -> monotone Funktion)
def bernstein(c, x):
    """
    c: array of coefficients c_0..c_n (wenn c monoton wachsend -> B_n monoton)
    x: array-like in [0,1]
    """
    x = np.asarray(x)
    n = len(c) - 1
    # Kombinatorische Faktoren
    binom = np.array([np.math.comb(n, k) for k in range(n+1)])[:, None]  # shape (n+1,1)
    x_pow = np.array([x**k for k in range(n+1)])                         # shape (n+1, len(x))
    one_minus = np.array([(1.0 - x)**(n - k) for k in range(n+1)])        # shape (n+1, len(x))
    terms = (c[:, None] * binom) * x_pow * one_minus                     # shape (n+1, len(x))
    return terms.sum(axis=0)

b_coefs = y_noisy.copy()   # hier: direkte Wahl der Koeffizienten = knot-values (monoton)
bern_vals = bernstein(b_coefs, x_fine)

# Plot
plt.figure(figsize=(10, 6))
plt.plot(x_fine, poly_vals, label=f'Polynom-Regression (deg {poly_deg})', linewidth=1)
plt.plot(x_fine, iso_vals_fine, label='Isotone Regression (stufig)', linewidth=1)
plt.plot(x_fine, pchip_vals, label='PCHIP (monotone kubische Interp.)', linewidth=1)
plt.plot(x_fine, bern_vals, label='Bernstein-Polynom (monotone Koeff.)', linewidth=1)
plt.scatter(x_pts, y_noisy, color='k', label='Knoten (strict monotone)', zorder=3)
plt.ylim(-0.05, 1.05)
plt.xlim(0, 1)
plt.title('Vergleich: Polynom vs. monotone Fits für CDF-ähnliche Punkte')
plt.xlabel('$x$')
plt.ylabel('$F(x)$')
plt.legend()
plt.grid(True)
plt.tight_layout()

# Anzeigen / optional als Datei speichern
plt.show()
# plt.savefig("cdf_monotone_compare.png", dpi=300)
