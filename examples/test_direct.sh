#!/bin/bash

OPT_LVL=O0
PASS_PLUGIN_DIR="/home/paul/Documents/JuFo-2026/obfuscator-pass/build/Obfuscator.so"
FILENAME="example"
PROBABILITY=75

# -Xclang -load forces .so into process memory before LLVM option parser runs
# -mllvm -pop-probability=$PROBABILITY \
clang-18 -$OPT_LVL -g \
	-fpass-plugin=$PASS_PLUGIN_DIR \
	-Xclang -load -Xclang $PASS_PLUGIN_DIR \
	-mllvm -pop-probability=$PROBABILITY \
	${FILENAME}.c \
	-o $FILENAME