#include <stdio.h>
#include <limits.h>
#include <float.h>

#define OBFUSCATE __attribute__((annotate("POP")))

OBFUSCATE void foo(double x)
{
  printf("foo %f\n", x);
  // printf("foo\n");
  volatile int a = 1;
  volatile int b = 2;
  volatile int c = a % b;
  volatile int d = c + b * a;
  //__asm__("int3");
} 

int bar(int x)
{
  int y = x + 1;
  printf("bar %i\n", y);
  return y;
}

int main()
{
  foo(3.141592653);
  return 0;
}