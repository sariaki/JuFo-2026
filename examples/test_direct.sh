#!/bin/bash

OPT_LVL=O3
PASS_PLUGIN_DIR="/home/paul/Documents/JuFo-2026/obfuscator-pass/build/Obfuscator.so"
FILENAME="example"

clang-18 -$OPT_LVL \
	-fpass-plugin=$PASS_PLUGIN_DIR \
	${FILENAME}.c \
	-o $FILENAME