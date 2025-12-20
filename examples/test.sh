#!/bin/bash

OPT_LVL=O1

# Compile source to bitcode using clang-18 (matching opt version)
clang-18 -g -O0 -S -emit-llvm ./example.c -o example.ll
clang-18 -g -O0 -emit-llvm -c example.c -o example.bc

# Run the pass using opt-18
/usr/bin/opt-18 \
  -load-pass-plugin="/home/paul/Documents/JuFo-2026/obfuscator-pass/build/Obfuscator.so" \
  -passes=POP \
  example.bc -o example_obf.bc

# Disassemble to verify
llvm-dis-18 example_obf.bc -o example_obf.ll

# Compile to final executable (using clang-18 for safety)
clang-18 -$OPT_LVL -g example_obf.bc -o example