import os
import subprocess
import sys
from pathlib import Path
from termcolor import colored

# Configuration
BENCHMARK_DIR = Path("/home/paul/Documents/JuFo-2026/evaluation/obfuscation-benchmarks")
OUTPUT_DIR = Path("/home/paul/Documents/JuFo-2026/evaluation/output")
OBFUSCATOR_SO = Path("/home/paul/Documents/JuFo-2026/obfuscator-pass/build/Obfuscator.so")
OPT_LVL = "O0"
CLANG = "clang-18"
OPT = "/usr/bin/opt-18"
LLVM_DIS = "llvm-dis-18"

# TODO: rewrite this function to just call clang directly with the pass
def obfuscate_file(source_file: Path, output_dir: Path) -> bool:
    try:
        # Generate output filenames
        bc_file = output_dir / f"{source_file.stem}.bc"
        obf_bc_file = output_dir / f"{source_file.stem}_obf.bc"
        obf_ll_file = output_dir / f"{source_file.stem}_obf.ll"
        output_exe = output_dir / source_file.stem

        # Compile to bitcode
        # This needs to be O0 to prevent LLVM optimizations from interfering
        # We can always optimize later
        # print(f"Compiling {source_file.name} to bitcode...")
        subprocess.run(
            [CLANG, "-g", f"-O0", "-emit-llvm", "-c", str(source_file), "-o", str(bc_file)],
            check=True
        )

        # Run obfuscation pass
        # print(f"Running obfuscation pass on {source_file.name}...")
        subprocess.run(
            [OPT, "-load-pass-plugin", str(OBFUSCATOR_SO), "-passes=POP", str(bc_file), "-o", str(obf_bc_file)],
            check=True
        )

        # Disassemble
        # print(f"Disassembling {source_file.name}...")
        subprocess.run(
            [LLVM_DIS, str(obf_bc_file), "-o", str(obf_ll_file)],
            check=True
        )

        # Compile to executable
        # print(f"Compiling to executable...")
        subprocess.run(
            [CLANG, f"-{OPT_LVL}", "-g", str(obf_bc_file), "-o", str(output_exe)],
            check=True
        )

        # print(f"✓ Successfully obfuscated {source_file.name}\n")
        return True
    except subprocess.CalledProcessError as e:
        print(colored(f"✗ Error processing {source_file.name}: {e}\n", "red"))
        return False

def main():
    global BENCHMARK_DIR
    dir = input("Enter subdirectory of benchmarks (or press Enter for default): ").strip()
    BENCHMARK_DIR = BENCHMARK_DIR / dir if dir else BENCHMARK_DIR / "basic-algorithms"

    if not BENCHMARK_DIR.exists():
        print(f"Error: Benchmark directory not found: {BENCHMARK_DIR}")
        sys.exit(1)

    if not OBFUSCATOR_SO.exists():
        print(f"Error: Obfuscator.so not found: {OBFUSCATOR_SO}")
        sys.exit(1)

    # Find all C/C++ files
    c_files = list(BENCHMARK_DIR.rglob("*.c")) + list(BENCHMARK_DIR.rglob("*.cpp"))
    
    if not c_files:
        print(f"No C/C++ files found in {BENCHMARK_DIR}")
        sys.exit(1)

    print(f"Found {len(c_files)} C/C++ files to obfuscate\n")

    # Create output directory
    OUTPUT_DIR.mkdir(exist_ok=True)

    # Process each file
    successful = 0
    for source_file in c_files:
        if obfuscate_file(source_file, OUTPUT_DIR):
            successful += 1

    print(f"\nCompleted: {successful}/{len(c_files)} files successfully obfuscated")

if __name__ == "__main__":
    main()