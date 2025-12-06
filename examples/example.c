#include <stdio.h>
#include <limits.h>
#include <float.h>

#define OBFUSCATE __attribute__((annotate("POP")))

OBFUSCATE void foo(int x)
{
  printf("foo %i\n", x);
  //__asm__("int3");
} 

OBFUSCATE int bar(int x)
{
  int y = x + 1;
  printf("bar %i", y);
  return y;
}

int main()
{
  foo(123123);
  return 0;
}