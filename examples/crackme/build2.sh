#!/bin/bash

OPT_LVL=O0
PASS_PLUGIN_DIR="/home/paul/Documents/JuFo-2026/obfuscator-pass/build/Obfuscator.so"
FILENAME="crackme2_obf"
LVL=100
RUNS=3

# Only use -fpass-plugin. Remove -Xclang -load.
clang-18 -static -$OPT_LVL -g \
	-fpass-plugin=$PASS_PLUGIN_DIR \
	-Xclang -load -Xclang $PASS_PLUGIN_DIR \
	-mllvm -pop-lvl=$LVL \
	-mllvm -pop-runs-per-fn=$RUNS \
	${FILENAME}.c \
	-o $FILENAME