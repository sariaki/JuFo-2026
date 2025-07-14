import numpy as np
import matplotlib.pyplot as plt

# 1. Sample from Uniform(0, 1), avoiding exact 0.5 to prevent infinite values
U = np.random.uniform(low=0.0001, high=0.9999, size=1_000_000)
X = np.tan(np.pi * U)

x = np.arange(0, 1, 0.01)
y = np.tan(np.pi * x)

# 2. Plot histogram
fig, axis = plt.subplots(2, 2)
axis[0, 0].hist(X, bins=1000, density=True, range=(-25, 25), color='skyblue', edgecolor='blue')

axis[0, 1].plot(x, y)
# 3. Plot settings
# plt.title(r"Distribution of $X = \tan(\pi U)$ where $U \sim \mathcal{U}(0,1)$")
# plt.xlabel("x")
# plt.ylabel("Probability Density")
# plt.grid(True)
# plt.xlim(-25, 25)

plt.show()