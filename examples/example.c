#include <stdio.h>
#include <limits.h>
#include <float.h>

__attribute__((annotate("insert_stochastic_predicate")))
void foo(double x)
{
  printf("foo %d\n", x);
  //__asm__("int3");
} 

int main()
{
  foo(DBL_MAX);
  return 0;
}