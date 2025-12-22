import os
import subprocess
import sys
from pathlib import Path
import numpy as np
from termcolor import colored
import matplotlib.pyplot as plt
from capstone import *
from elftools.elf.elffile import ELFFile
import math
from collections import Counter
import time

# Configuration
BENCHMARK_DIR = Path("/home/paul/Documents/JuFo-2026/evaluation/obfuscation-benchmarks")
OUTPUT_DIR = Path("/home/paul/Documents/JuFo-2026/evaluation/output")
OBFUSCATOR_SO = Path("/home/paul/Documents/JuFo-2026/obfuscator-pass/build/Obfuscator.so")
OPT_LVL = "O3"
CLANG = "clang-18"
OPT = "/usr/bin/opt-18"
LLVM_DIS = "llvm-dis-18"

dataset_colors = ['#9671bd', '#7e7e7e', '#77b5b6'] 
dataset_line_colors = ['#6a408d', '#4e4e4e', '#378d94']

script_dir = os.path.dirname(os.path.abspath(__file__))
os.chdir(script_dir)

# Statistical information from benchmark
names = []
times, obf_times = [], []
sizes, obf_sizes = [], []
entropy, obf_entropy = [], []
opcodes, opcodes_obf = [], []
instr_counts, obf_instr_counts = [], []
complexities, obf_complexities = [], []

def file_entropy(path: str) -> float:
    with open(path, "rb") as f:
        data = f.read()

        if not data:
            return 0.0
        
        counts = Counter(data)
        length = len(data)
        entropy = 0.0

        for freq in counts.values():
            p = freq / length
            entropy -= p * math.log2(p)

        return entropy  # bits per byte, range [0, 8]

def get_opcode_distribution(file_path: Path) -> Counter:
    opcode_counts = Counter()
    
    try:
        with open(file_path, 'rb') as f:
            elffile = ELFFile(f)
            text_section = elffile.get_section_by_name('.text')
            
            if not text_section:
                return opcode_counts

            code = text_section.data()
            base_addr = text_section['sh_addr']

            md = Cs(CS_ARCH_X86, CS_MODE_64)
            
            # disasm_lite is faster as it only returns (address, size, mnemonic, op_str)
            for _, _, mnemonic, _ in md.disasm_lite(code, base_addr):
                opcode_counts[mnemonic] += 1
                
    except Exception as e:
        print(f"Error analyzing opcodes in {file_path}: {e}")
        
    return opcode_counts

def get_instruction_count(opcode_dist: Counter) -> int:
    return sum(opcode_dist.values())

def get_cyclomatic_complexity(opcode_dist: Counter) -> int:
    cond_jumps = {
        'je', 'jne', 'jz', 'jnz', 'jg', 'jge', 'ja', 'jae',
        'jl', 'jle', 'jb', 'jbe', 'jo', 'jno', 'js', 'jns',
        'jp', 'jnp', 'jcxz', 'jecxz', 'jrcxz'
    }
    p = sum(count for op, count in opcode_dist.items() if op in cond_jumps)
    return p + 1

def obfuscate_file(source_file: Path, output_dir: Path) -> bool:
    try:
        # Generate output filenames
        output_exe = output_dir / source_file.stem
        output_obf_exe = output_dir / f"{source_file.stem}_obf"

        # Compile original
        t = time.time_ns()
        subprocess.run(
            [
                CLANG,
                f"-{OPT_LVL}",
                str(source_file),
                "-o",
                str(output_exe)
            ],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
        t = time.time_ns() - t

        # Obfuscate
        t_obf = time.time_ns()
        subprocess.run(
            [
                CLANG,
                f"-{OPT_LVL}",
                # both ways to load plugin (keep both if your shell used both)
                "-fpass-plugin=" + str(OBFUSCATOR_SO),
                "-Xclang", "-load", "-Xclang", str(OBFUSCATOR_SO),
                "-mllvm", "-pop-probability=100",
                str(source_file),
                "-o", str(output_obf_exe)
            ],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
        t_obf = time.time_ns() - t_obf

        # Record name without path
        names.append(source_file.stem)

        # Compillation times
        times.append(t / 1e6)  # Convert to ms
        obf_times.append(t_obf / 1e6)  # Convert to ms

        # Size differences
        size = output_exe.stat().st_size
        obf_size = output_obf_exe.stat().st_size
        sizes.append(size)
        obf_sizes.append(obf_size)

        # # Execution time
        # t_exec = time.time_ns()
        # subprocess.run(
        #     [str(output_exe)],
        #     check=True,
        #     stdout=subprocess.DEVNULL,
        #     stderr=subprocess.DEVNULL
        # )
        # t_exec = time.time_ns() - t_exec

        # t_obf_exec = time.time_ns()
        # subprocess.run(
        #     [str(output_obf_exe)],
        #     check=True,
        #     stdout=subprocess.DEVNULL,
        #     stderr=subprocess.DEVNULL
        # )
        # t_obf_exec = time.time_ns() - t_obf_exec

        # exec_time.append(t_exec / 1e6)  # Convert to ms
        # obf_exec_time.append(t_obf_exec / 1e6)  # Convert to ms

        # Entropy difference
        entropy_ = file_entropy(output_exe)
        obf_entropy_ = file_entropy(output_obf_exe)
        entropy.append(entropy_)
        obf_entropy.append(obf_entropy_)

        # Opcode distribution
        opcode_dist = get_opcode_distribution(output_exe)
        opcode_dist_obf = get_opcode_distribution(output_obf_exe)
        opcodes.append(opcode_dist)
        opcodes_obf.append(opcode_dist_obf)

        # Instruction count
        instr_counts.append(get_instruction_count(opcode_dist))
        obf_instr_counts.append(get_instruction_count(opcode_dist_obf))

        # Cyclomatic complexity
        complexities.append(get_cyclomatic_complexity(opcode_dist))
        obf_complexities.append(get_cyclomatic_complexity(opcode_dist_obf))

        return True
    except subprocess.CalledProcessError as e:
        print(colored(f"✗ {source_file.name}:\n  {e}\n", "red"))
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

    # Plot results
    plt.rcParams.update({
        'font.family': 'Courier New',
        'font.size': 20,
        'axes.titlesize': 20,
        'axes.labelsize': 20,
        'xtick.labelsize': 18,
        'ytick.labelsize': 18,
        'legend.fontsize': 20,
        'figure.titlesize': 20
    })

    # Plot all measured aspects (time, size etc.) in separate plots
    names_arr = np.array(names)
    times_arr = np.array(times)
    obf_times_arr = np.array(obf_times)
    x = np.arange(len(names_arr))

    # Compilation time
    # width of each bar (smaller if many groups)
    width = 0.35

    fig, ax = plt.subplots(figsize=(max(10, len(names_arr)*0.3), 8))

    # grouped bars: shift each group's bars left/right by width/2
    ax.bar(x - width/2, times_arr, width, label="Original",
        color=dataset_line_colors[2], capsize=4)
    ax.bar(x + width/2, obf_times_arr, width, label="Obfuskiert",
        color=dataset_line_colors[0], capsize=4)

    # labels, ticks
    ax.set_xlabel("Datei")
    ax.set_ylabel("Kompilationszeit (ms)")
    ax.set_xticks(x)
    ax.set_xticklabels(names_arr, rotation=45, ha="right")

    handles, labels = ax.get_legend_handles_labels()
    ax.legend(
        handles,
        labels,
        loc='upper center',
        bbox_to_anchor=(0.5, 1.18),
        ncols=2,
        frameon=False,
        fontsize='large'
    )

    plt.tight_layout()
    plt.show()
    fig.savefig("output/compilation_time.pdf")

    # Size
    sizes_arr = np.array(sizes)
    obf_sizes_arr = np.array(obf_sizes)

    fig, ax = plt.subplots(figsize=(max(10, len(names_arr)*0.3), 8))

    ax.bar(x - width/2, sizes_arr, width, label="Original",
        color=dataset_line_colors[2], capsize=4)
    ax.bar(x + width/2, obf_sizes_arr, width, label="Obfuskiert",
        color=dataset_line_colors[0], capsize=4)

    ax.set_xlabel("Datei")
    ax.set_ylabel("Dateigröße (Bytes)")
    ax.set_xticks(x)
    ax.set_xticklabels(names_arr, rotation=45, ha="right")

    handles, labels = ax.get_legend_handles_labels()
    ax.legend(
        handles,
        labels,
        loc='upper center',
        bbox_to_anchor=(0.5, 1.18),
        ncols=2,
        frameon=False,
        fontsize='large'
    )

    plt.tight_layout()
    plt.show()
    fig.savefig("output/size.pdf")

    # Entropy
    entropy_arr = np.array(entropy)
    obf_entropy_arr = np.array(obf_entropy)

    fig, ax = plt.subplots(figsize=(max(10, len(names_arr)*0.3), 8))

    ax.bar(x - width/2, entropy_arr, width, label="Original",
        color=dataset_line_colors[2], capsize=4)
    ax.bar(x + width/2, obf_entropy_arr, width, label="Obfuskiert",
        color=dataset_line_colors[0], capsize=4)
    
    ax.set_xlabel("Datei")
    ax.set_ylabel("Entropie (Bits pro Byte)")
    ax.set_xticks(x)
    ax.set_xticklabels(names_arr, rotation=45, ha="right")

    handles, labels = ax.get_legend_handles_labels()
    ax.legend(
        handles,
        labels,
        loc='upper center',
        bbox_to_anchor=(0.5, 1.18),
        ncols=2,
        frameon=False,
        fontsize='large'
    )

    plt.tight_layout()
    plt.show()
    fig.savefig("output/entropy.pdf")

    # Instruction count
    instr_counts_arr = np.array(instr_counts)
    obf_instr_counts_arr = np.array(obf_instr_counts)

    fig, ax = plt.subplots(figsize=(max(10, len(names_arr)*0.3), 8))

    ax.bar(x - width/2, instr_counts_arr, width, label="Original",
        color=dataset_line_colors[2], capsize=4)
    ax.bar(x + width/2, obf_instr_counts_arr, width, label="Obfuskiert",
        color=dataset_line_colors[0], capsize=4)

    ax.set_xlabel("Datei")
    ax.set_ylabel("#Anweisungen")
    ax.set_xticks(x)
    ax.set_xticklabels(names_arr, rotation=45, ha="right")

    handles, labels = ax.get_legend_handles_labels()
    ax.legend(
        handles,
        labels,
        loc='upper center',
        bbox_to_anchor=(0.5, 1.18),
        ncols=2,
        frameon=False,
        fontsize='large'
    )

    plt.tight_layout()
    plt.show()
    fig.savefig("output/instruction_count.pdf")

    # Cyclomatic complexity
    complexities_arr = np.array(complexities)
    obf_complexities_arr = np.array(obf_complexities)

    fig, ax = plt.subplots(figsize=(max(10, len(names_arr)*0.3), 8))
    ax.bar(x - width/2, complexities_arr, width, label="Original",
        color=dataset_line_colors[2], capsize=4)
    ax.bar(x + width/2, obf_complexities_arr, width, label="Obfuskiert",
        color=dataset_line_colors[0], capsize=4)
    
    ax.set_xlabel("Datei")
    ax.set_ylabel("Zyklomatische Komplexität")
    ax.set_xticks(x)
    ax.set_xticklabels(names_arr, rotation=45, ha="right")

    handles, labels = ax.get_legend_handles_labels()
    ax.legend(
        handles,
        labels,
        loc='upper center',
        bbox_to_anchor=(0.5, 1.18),
        ncols=2,
        frameon=False,
        fontsize='large'
    )

    plt.tight_layout()
    plt.show()
    fig.savefig("output/complexity.pdf")

        # Opcode distribution (10 most common)
    total_orig = Counter()
    total_obf = Counter()
    for c in opcodes: total_orig.update(c)
    for c in opcodes_obf: total_obf.update(c)

    common_opcodes = [op for op, count in total_orig.most_common(10)]
    
    orig_vals = [total_orig[op] for op in common_opcodes]
    obf_vals = [total_obf[op] for op in common_opcodes]

    x = np.arange(len(common_opcodes))
    width = 0.35

    fig, ax = plt.subplots(figsize=(12, 6))
    ax.bar(x - width/2, orig_vals, width, label='Original', color=dataset_line_colors[2])
    ax.bar(x + width/2, obf_vals, width, label='Obfuskiert', color=dataset_line_colors[0])

    ax.set_ylabel('Häufigkeit')
    ax.set_title('Häufigsten Mnemonics vor/nach der Obfuskation')
    ax.set_xticks(x)
    ax.set_xticklabels(common_opcodes)
    ax.legend()
    
    plt.tight_layout()
    fig.savefig("output/opcode_dist.pdf")
    plt.show()

if __name__ == "__main__":
    main()