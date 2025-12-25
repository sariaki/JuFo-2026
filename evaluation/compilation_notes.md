### LLVM Test Suite
- https://llvm.org/docs/TestSuiteGuide.html
```bash
cmake -DCMAKE_C_COMPILER=/usr/bin/clang-18 \
      -DCMAKE_CXX_COMPILER=/usr/bin/clang++-18 \
      -DTEST_SUITE_SUBDIRS="SingleSource;MultiSource" \
      -C ../llvm-test-suite/cmake/caches/O3.cmake \
      ../llvm-test-suite

make -j$(nproc)

lit -v -j 1 -o results.json .

../llvm-test-suite/utils/compare.py results_a.json results_b.json
```

```
Program                                       exec_time
                                              results  
SingleSour...-algebra/solvers/ludcmp/ludcmp    60.71   
SingleSour...h/linear-algebra/solvers/lu/lu    60.68   
SingleSour...h/stencils/seidel-2d/seidel-2d    32.42   
SingleSour...ebra/solvers/cholesky/cholesky    28.82   
SingleSour.../floyd-warshall/floyd-warshall    23.75   
MultiSourc...Benchmarks/SciMark2-C/scimark2    20.07   
MultiSource/Benchmarks/PAQ8p/paq8p             17.27   
Bitcode/Be...ral_grid/halide_bilateral_grid    16.43   
Bitcode/Be...placian/halide_local_laplacian    11.76   
SingleSour...olvers/gramschmidt/gramschmidt     9.42   
MultiSourc...enchmarks/mafft/pairlocalalign     9.29   
MultiSource/Applications/lua/lua                8.00   
SingleSour...bench/medley/nussinov/nussinov     7.92   
SingleSour...rks/Polybench/stencils/adi/adi     7.32   
SingleSour...inear-algebra/blas/syr2k/syr2k     6.26   
         exec_time
run        results
count  2039.000000
mean   0.283004   
std    2.396889   
min    0.000000   
25%    0.000300   
50%    0.000400   
75%    0.000400   
max    60.714900
```

```bash
PROBABILITY=100
PASS_PLUGIN_DIR="/home/paul/Documents/JuFo-2026/obfuscator-pass/build/Obfuscator.so"
cmake -DCMAKE_C_COMPILER=/usr/bin/clang-18 \
      -DCMAKE_CXX_COMPILER=/usr/bin/clang++-18 \
      -DTEST_SUITE_SUBDIRS="SingleSource;MultiSource" \
      -DCMAKE_C_FLAGS="-fpass-plugin=$PASS_PLUGIN_DIR -Xclang -load -Xclang $PASS_PLUGIN_DIR -mllvm -pop-probability=$PROBABILITY" \
      -DCMAKE_CXX_FLAGS="-fpass-plugin=$PASS_PLUGIN_DIR -Xclang -load -Xclang $PASS_PLUGIN_DIR -mllvm -pop-probability=$PROBABILITY" \
      -C ../llvm-test-suite/cmake/caches/O3.cmake \
      ../llvm-test-suite

make -j$(nproc)

lit -v -j 1 -o results.json .

../llvm-test-suite/utils/compare.py results.json
```

### Postgresql
```bash
CC="clang-18"
CXX="clang++-18"
PROBABILITY=100
PASS_PLUGIN_DIR="/home/paul/Documents/JuFo-2026/obfuscator-pass/build/Obfuscator.so"
INSTALL_DIR=$(pwd)/pg_build
MY_PASS_FLAGS="-fpass-plugin=$PASS_PLUGIN_DIR -Xclang -load -Xclang $PASS_PLUGIN_DIR -mllvm -pop-probability=$PROBABILITY -Wno-unused-command-line-argument"

./configure --prefix="$INSTALL_DIR" \
            CC="$CC" \
            CXX="$CXX" \
            CFLAGS="$MY_PASS_FLAGS" \
            CXXFLAGS="$MY_PASS_FLAGS" \
            --without-readline --without-zlib
```

after Obfuscation:
du -sh "$INSTALL_DIR"
89M	/home/paul/Documents/JuFo-2026/evaluation/big/pg_build

### coreutils
```bash
./configure CC=clang-18 \
            CFLAGS="-O3 -fpass-plugin=/home/paul/Documents/JuFo-2026/obfuscator-pass/build/Obfuscator.so \
            -Xclang -load -Xclang /home/paul/Documents/JuFo-2026/obfuscator-pass/build/Obfuscator.so \
            -mllvm -pop-probability=75"

make -j$(nproc)
```

### sqlite
```bash
hyperfine --warmup 3 --prepare \
  './sqlite3_base ":memory:" "WITH RECURSIVE c(x) AS (VALUES(1) UNION ALL SELECT x+1 FROM c WHERE x<100000) SELECT AVG(x*x) FROM c;"' \
  './sqlite3_obf ":memory:" "WITH RECURSIVE c(x) AS (VALUES(1) UNION ALL SELECT x+1 FROM c WHERE x<100000) SELECT AVG(x*x) FROM c;"'
```
