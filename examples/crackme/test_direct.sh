#!/bin/bash

# OPT_LVL=O3
# PASS_PLUGIN_DIR="/home/paul/Documents/JuFo-2026/obfuscator-pass/build/Obfuscator.so"
# FILENAME="example"
# PROBABILITY=75

# # -Xclang -load forces .so into process memory before LLVM option parser runs
# # 	-mllvm -pop-probability=$PROBABILITY \
# clang-18 -$OPT_LVL -g \
# 	-fpass-plugin=$PASS_PLUGIN_DIR \
# 	-Xclang -load -Xclang $PASS_PLUGIN_DIR \
# 	${FILENAME}.c \
# 	-o $FILENAME

OPT_LVL=O3
PASS_PLUGIN_DIR="/home/paul/Documents/JuFo-2026/obfuscator-pass/build/Obfuscator.so"
FILENAME="example"

# Only use -fpass-plugin. Remove -Xclang -load.
clang-18 -static -$OPT_LVL -g \
	-fpass-plugin=$PASS_PLUGIN_DIR \
	${FILENAME}.c \
	-o $FILENAME