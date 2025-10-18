from threading import *
from time import *
from matplotlib import pyplot as plt
from statistics import *
import numpy as np
def thread(arg):
    for i in range(arg):
        pass

if __name__ == "__main__":
    N = 1000
    K = 10

    x = np.arange(N)
    y = np.zeros(N)
    for i in range(N):
        t = perf_counter_ns()
        th = Thread(target=thread, args=(10,))
        th.start()
        th.join()
        t2  = perf_counter_ns() - t
        y[i] = t2

    unique, counts = np.unique(y.astype(np.int64), return_counts=True)
    plt.plot(unique, counts)
    plt.show()
