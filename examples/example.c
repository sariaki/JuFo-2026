#include <stdio.h>
#include <limits.h>
#include <float.h>
#include <stdlib.h>
#include <stdint.h>

#define OBFUSCATE __attribute__((annotate("POP")))

// https://stackoverflow.com/questions/33010010/how-to-generate-random-64-bit-unsigned-integer-in-c
uint64_t rand_uint64(void) {
  uint64_t r = 0;
  for (int i=0; i<64; i += 15 /*30*/) {
    r = r*((uint64_t)RAND_MAX + 1) + rand();
  }
  return r;
}

uint64_t wrapper(void) {
  return rand_uint64();
}

OBFUSCATE void foo(uint64_t x)
{
  printf("foo %lu\n", x);
  // printf("foo\n");
  volatile int a = 1;
  volatile int b = 2;
  volatile int c = a % b;
  volatile int d = c + b * a;
  //__asm__("int3");
} 

OBFUSCATE int bar(int x)
{
  int y = x + 1;
  printf("bar %i\n", y);
  return y;
}

int main()
{
  foo(wrapper());
  return 0;
}