# Probabilistic Opaque Predicates LLVM Pass

#### Build Instructions

```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j
```

#### Run Instructions

```bash
OPT_LVL=O3
PASS_PLUGIN_DIR="./build/Obfuscator.so"
FILENAME="hello_world"

clang-18 -$OPT_LVL -g \
	-fpass-plugin=$PASS_PLUGIN_DIR \
	-Xclang -load -Xclang $PASS_PLUGIN_DIR \
	${FILENAME}.c \
	-o $FILENAME
```