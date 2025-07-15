#include <iostream>
#include <cstdlib>   // rand(), RAND_MAX, srand()
#include <cmath>     // log(), sqrt(), cos(), fabs()
#include <ctime>     // time()

// 1) Uniform on [0,1)
double uniform01() {
    return rand() / (RAND_MAX + 1.0);
}

// 2) Box–Muller: standard normal N(0,1)
double standard_normal() {
    double u1, u2;
    // ensure u1>0 so log(u1) is defined
    do {
        u1 = uniform01();
    } while (u1 <= 0.0);
    u2 = uniform01();
    double r = sqrt(-2.0 * log(u1));
    double theta = 2.0 * M_PI * u2;
    return r * cos(theta);
}

int main() {
    // seed once
    srand(static_cast<unsigned>(time(nullptr)));

    // Compute epsilon so that P(|Z| <= ε) = 0.99
    const double EPSILON = 2.5758293035489004;
    std::cout << "epsilon for 99% interval is ±" << EPSILON << "\n\n";

    double z = standard_normal();
	std::cout << z << "\n";
	
	if (z > 2.576) {
		std::cout << "WHAAA" << "\n";
	}
	else {
		std::cout << "XD" << "\n";
	}
    return 0;
}