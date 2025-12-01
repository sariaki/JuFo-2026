#!/bin/bash

OPT_LVL=O0

# 1. Compile source to bitcode using CLANG-18 (Matches your opt-18)
clang-18 -g -$OPT_LVL -S -emit-llvm ./example.c -o example.ll
clang-18 -g -$OPT_LVL -emit-llvm -c example.c -o example.bc

# 2. Run the pass using opt-18
#    (We explicitly use the binary we know exists from your logs)
/usr/bin/opt-18 \
  -load-pass-plugin="/home/paul/Documents/JuFo-2026/obfuscator-pass/build/Obfuscator.so" \
  -passes=obfuscator \
  example.bc -o example_obf.bc

# 3. Disassemble to verify
llvm-dis-18 example_obf.bc -o example_obf.ll

# 4. Compile to final executable (using clang-18 for safety)
clang-18 -$OPT_LVL -g example_obf.bc -o example