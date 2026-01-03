#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 PROBABILITY"
  exit 1
fi
PROBABILITY="$1"

# directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# adjust if your llvm-test-suite is elsewhere — we expect it to be sibling of this repo root
LLVM_TEST_SUITE_DIR="$SCRIPT_DIR/../llvm-test-suite"
O3_CACHE="$LLVM_TEST_SUITE_DIR/cmake/caches/O3.cmake"

PASS_PLUGIN_DIR="/home/paul/Documents/JuFo-2026/obfuscator-pass/build/Obfuscator.so"
if [ ! -f "$PASS_PLUGIN_DIR" ]; then
  echo "Warning: PASS_PLUGIN_DIR '$PASS_PLUGIN_DIR' does not exist. Continue anyway? (ctrl-c to abort)"
  sleep 1
fi

if [ ! -d "$LLVM_TEST_SUITE_DIR" ]; then
  echo "Error: expected test-suite directory at: $LLVM_TEST_SUITE_DIR"
  echo "pwd: $(pwd)"
  exit 1
fi

if [ ! -f "$O3_CACHE" ]; then
  echo "Error: expected cache file at: $O3_CACHE"
  echo "Available files in directory:"
  ls -la "$(dirname "$O3_CACHE")" || true
  exit 1
fi

# assemble the flags (quoted properly)
C_FLAGS="-fpass-plugin=${PASS_PLUGIN_DIR} -Xclang -load -Xclang ${PASS_PLUGIN_DIR} -mllvm -pop-probability=${PROBABILITY}"
CXX_FLAGS="$C_FLAGS"

cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_C_COMPILER=/usr/bin/clang-18 \
      -DCMAKE_CXX_COMPILER=/usr/bin/clang++-18 \
      -DTEST_SUITE_BENCHMARKING_ONLY=ON \
      -DTEST_SUITE_SUBDIRS="MultiSource" \
      -DCMAKE_C_FLAGS="$C_FLAGS" \
      -DCMAKE_CXX_FLAGS="$CXX_FLAGS" \
      -C "$O3_CACHE" \
      "$LLVM_TEST_SUITE_DIR"

make -j"$(nproc)"

RESULTS_FILE="results${PROBABILITY}.json"
lit -v -j "$(nproc)" -o "$RESULTS_FILE" . # --timeout=300 --filter-out="MallocBench/gs|lua"

echo "Done. Results saved to: $(pwd)/$RESULTS_FILE"
