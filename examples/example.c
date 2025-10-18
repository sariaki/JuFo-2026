#include <stdio.h>
#include <limits.h>
#include <float.h>

__attribute__((annotate("insert_stochastic_predicate")))
void foo(int x)
{
  printf("foo %i\n", x);
  //__asm__("int3");
} 

int main()
{
  foo(123123);
  return 0;
}