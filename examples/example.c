#include <stdio.h>

__attribute__((insert_stochastic_predicate))
void foo()
{
  printf("foo\n");
} 

int main()
{
  foo();
  return 0;
}