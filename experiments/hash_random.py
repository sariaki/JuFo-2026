import random
import hashlib
from matplotlib import pyplot as plt
import numpy as np

def get_random_number():
    return random.paretovariate(1.5) # return float to preserve entropy

def get_uniform_int_hashed(m):
    # Generate a practically uniform random integer in [0, n-1] using hashing.

    n = get_random_number()
    
    # Hash the string representation of the number
    num_bytes = str(n).encode()
    hash_object = hashlib.sha256(num_bytes)
    hash_hex = hash_object.hexdigest()
    
    # Convert str-hash to int
    hash_int = int(hash_hex, 16)
    
    # Scale
    return hash_int % m

N = 1000000
K = 10
x = np.arange(K)
y = np.zeros(K, dtype=int)

print("Generating uniform numbers between 0 and 9:")
for i in range(N):
    u = get_uniform_int_hashed(K)
    y[u] += 1

# print("Counts per bin:", y)

plt.figure(figsize=(10, 6))

plt.title(f"Distribution of {N} numbers through hashing")
plt.xlabel("Generated Number")
plt.ylabel("Frequency")
plt.legend()

ev = N / K
plt.axhline(y=ev, color='r', linestyle='--', label=f'Expected Value ({int(ev)})')
plt.bar(x, y)

plt.show()
# plt.savefig("uniform_gen_hashing.png")