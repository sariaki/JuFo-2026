# Probabilistic Opaque Predicates LLVM Pass
Made for LLVM 18.

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
LVL=50 RUNS=1 PRED_PROB=99
MIN_DEG=3 MAX_DEG=6

clang -$OPT_LVL \
-fpass-plugin=$PASS_PLUGIN_DIR \
-Xclang -load -Xclang $PASS_PLUGIN_DIR \
-mllvm -pop-lvl=$LVL \
-mllvm -pop-pred-prob=$PRED_PROB \
-mllvm -pop-runs-per-fn=$RUNS \
-mllvm -pop-min-degree=$MIN_DEG \
-mllvm -pop-max-degree=$MAX_DEG \
${FILENAME}.c \
-o $FILENAME
```