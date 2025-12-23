#include <stdio.h>
#include <limits.h>
#include <float.h>
#include <stdlib.h>
#include <stdint.h>

#define OBFUSCATE __attribute__((annotate("POP")))

uint64_t rand_uint64(void)
{
  uint64_t r = 0;
  for (int i = 0; i < 64; i += 15)
  {
    r = r*((uint64_t)RAND_MAX + 1) + rand();
  }
  return r;
}

uint64_t wrapper(void) 
{
  return rand_uint64();
}

OBFUSCATE int main(int argc, char** argv)
{
  wrapper();
  return 0;
}