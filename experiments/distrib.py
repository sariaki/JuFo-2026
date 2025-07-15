import numpy as np
import matplotlib.pyplot as plt

U = np.random.uniform(low=0.0001, high=0.9999, size=1_000_000)
X = np.log(1/U)

x = np.arange(0.1, 1, 0.01)
y = np.tan(np.pi * x)
z = np.log(1/x)

# Plot
fig, axis = plt.subplots(1, 2)
axis[0].hist(X, bins=1000, density=True, range=(-25, 25), color='skyblue', edgecolor='blue')

# plt.title(r"Distribution of $X = \tan(\pi U)$ where $U \sim \mathcal{U}(0,1)$")
# plt.xlabel("x")
# plt.ylabel("Probability Density")
# plt.grid(True)
# plt.xlim(-10, 10)

axis[1].plot(x, y)
axis[1].plot(x, z)

# plt.title(r"Values of $X = \tan(\pi U)$")
# plt.xlabel("x")
# plt.ylabel("y")
# plt.grid(True)
# plt.xlim(-10, 10)

plt.show()