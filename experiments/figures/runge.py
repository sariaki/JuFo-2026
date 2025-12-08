import numpy as np
import matplotlib.pyplot as plt

def runge(x):
    return 1.0/(1 + 25 * x**2)

xs_dense = np.linspace(-1, 1, 500)
f_dense = runge(xs_dense)

# pick n+1 equispaced nodes and interpolate degree n
n = 16
x_nodes = np.linspace(-1, 1, n+1)
y_nodes = runge(x_nodes)
poly_coefs = np.polyfit(x_nodes, y_nodes, deg=n)     # polynomial interpolation
poly_interp = np.polyval(poly_coefs, xs_dense)

# Chebyshev nodes interpolation
cheb_nodes = np.cos((2*np.arange(n+1)+1)/(2*(n+1)) * np.pi)
y_cheb = runge(cheb_nodes)
poly_cheb = np.polyfit(cheb_nodes, y_cheb, deg=n)
cheb_interp = np.polyval(poly_cheb, xs_dense)

plt.plot(xs_dense, f_dense, label="Runge f(x)")
plt.plot(xs_dense, poly_interp, '--', label=f"Equispaced interp deg={n}")
plt.plot(xs_dense, cheb_interp, ':', label=f"Chebyshev interp deg={n}")
plt.scatter(x_nodes, y_nodes, c='k', s=10)
plt.legend()
plt.ylim(-1.5, 1.5)
plt.show()