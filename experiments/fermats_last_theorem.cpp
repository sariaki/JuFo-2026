#include <iostream>
#include <cmath> 

int foo(int a, int b, int c) {
	int x = 0;
	if (a*a*a + b*b*b == c*c*c) { // Die Multiplikation wird durchgeführt, damit wir nicht pow() aufrufen müssen und somit die symbolische Ausführungsmaschine verwirren.
		printf("predicate was true ???");
		x = 1;
	}
	else {
		printf("predicate was false!");
		x = 2;
	}
	return x;
}

int main() {
	volatile int x = foo(1, 2, 3);
	return x;
}