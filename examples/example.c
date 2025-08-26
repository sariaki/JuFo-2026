#include <stdio.h>

__attribute__((annotate("insert_stochastic_predicate")))
void foo(void* x)
{
  printf("foo %d\n", x);
} 

int main()
{
  foo((void*)1289778913);
  return 0;
}