import os
import angr
import numpy as np
import matplotlib.pyplot as plt
from scipy.spatial import distance
from scipy.stats import gaussian_kde
from pathlib import Path
import seaborn as sns
import random
import logging

# Styling and Setup

script_dir = os.path.dirname(os.path.abspath(__file__))
os.chdir(script_dir)
os.makedirs("output", exist_ok=True)

dataset_colors = ["#8b00c2", '#7e7e7e', "#006293"]
dataset_line_colors = ['#6a408d', '#4e4e4e', '#378d94']

plt.rcParams.update({
    'font.family': 'serif',
    'font.size': 14,
    'axes.titlesize': 16,
    'axes.labelsize': 14,
    'xtick.labelsize': 12,
    'ytick.labelsize': 12,
    'legend.fontsize': 12,
    'lines.linewidth': 2,
    'lines.markersize': 8,
    'figure.autolayout': True 
})

def format_ax(ax):
    ax.grid(True, which='major', linestyle='-', linewidth=0.75, alpha=0.25)
    ax.minorticks_on()
    ax.grid(True, which='minor', linestyle='-', linewidth=0.25, alpha=0.15)
    ax.set_axisbelow(True)

# Data Processing

logging.getLogger('cle').setLevel(logging.ERROR)
logging.getLogger('angr').setLevel(logging.ERROR)

DIR_BASE = "/home/paul/Documents/JuFo-2026/evaluation/llvm-test-suite-build/MultiSource"
DIR_OBF = "/home/paul/Documents/JuFo-2026/evaluation/llvm-test-suite-build_obfuscated/MultiSource"

MAX_BINARIES = None
PREDICATES_PER_BIN = None

CATEGORIES = {
    "Arithmetic": [
        "imul", "inc", "sub", "add", "idiv", "divsd", "sbb", 
        "subpd", "addpd", "mulpd", "divpd", "maxpd", "minpd", "sqrtpd"
    ],
    "Logical": [
        "and", "sar", "xor", "test", "shr", "shl", "or", "xorps", "xorpd", "orpd", "andpd"
    ],
    "DataTransfer": [
        "movaps", "movsd", "movabs", "movzx", "mov", "movss", "movsx", "movsxd", "stosd",
        "movapd", "movupd", "unpcklpd", "unpckhpd", "movhpd", "movlpd"
    ],
    "DataDimension": ["cvtss2sd", "cvtsi2sd", "cvtsd2ss", "cqo", "cdq", "cvttsd2si"],
    "Pointer": ["lea"],
    "Comparison": ["cmp", "ucomisd", "comisd"],
    "Jump": ["jle", "jne", "jge", "jae", "jl", "je", "jg", "jp", "ja", "jbe", "jno", "jmp"],
    "Stack": ["pop", "push", "call", "ret"],
    "Boolean": ["setge", "setne", "setg", "seta", "setb", "setl", "sete"],
    "Other": ["nop"]
}
OPCODE_MAP = {op: cat for cat, ops in CATEGORIES.items() for op in ops}
CAT_LIST = list(CATEGORIES.keys())

# Instructions that strongly indicate the specific opaque predicate from your example
OPAQUE_SIGNATURE = {
    "subpd", "addpd", "mulpd", "unpcklpd", "unpckhpd", "divpd", "maxpd", "minpd"
}

def is_executable_elf(path):
    if path.suffix in ['.o', '.a', '.bc', '.cmake', '.txt', '.sh', '.py']:
        return False
    try:
        if not os.access(path, os.R_OK): return False
        with open(path, 'rb') as f:
            header = f.read(4)
            return header == b'\x7fELF'
    except:
        return False

def extract_vectors(binary_path, select_opaque_only=False):
    vectors = []
    fname = os.path.basename(binary_path)
    
    try:
        proj = angr.Project(binary_path, auto_load_libs=False)
    except Exception as e:
        print(f"  {fname}: Failed to load project: {e}")
        return []

    try:
        cfg = proj.analyses.CFGFast(normalize=True, force_complete_scan=False)
        nodes = list(cfg.graph.nodes())
    except Exception as e:
        print(f"  {fname}: CFG Analysis failed: {e}")
        return []
    
    node_count = len(nodes)
    if node_count == 0:
        return []

    cond_jump_blocks = []
    
    for node in nodes:
        try:
            if not node.block: continue 
            insns = node.block.capstone.insns
            if not insns: continue
            
            last_mnemonic = insns[-1].insn.mnemonic
            
            # Must be a conditional jump
            if last_mnemonic.startswith('j') and last_mnemonic != 'jmp':
                
                if select_opaque_only:
                    # Check if this block contains the math heavy signature of predicate.
                    
                    opcodes = set(i.insn.mnemonic for i in insns)
                    
                    # Check for specific SIMD math ops
                    signature_hits = len(opcodes.intersection(OPAQUE_SIGNATURE))
                    
                    # Heuristic:
                    # If it has at least 2 different types of heavy math ops AND 
                    # the block isn't tiny, we assume it's the opaque predicate.
                    if signature_hits >= 2 and len(insns) > 5:
                        cond_jump_blocks.append(node.block)
                else:
                    # Standard logic for base binaries (take any conditional jump)
                    cond_jump_blocks.append(node.block)
                
        except Exception:
            continue

    if not cond_jump_blocks:
        msg = "opaque predicates" if select_opaque_only else "conditional jumps"
        print(f"  {fname}: Found 0 {msg} (filtered from {node_count} nodes).")
        return []
    
    # Extract Vectors
    if PREDICATES_PER_BIN:
        sample_size = min(len(cond_jump_blocks), PREDICATES_PER_BIN)
        sample = random.sample(cond_jump_blocks, sample_size)
    else:
        sample = cond_jump_blocks
    
    for block in sample:
        insns = block.capstone.insns
        # We analyze the window directly preceding the jump for the feature vector
        preamble = insns[-11:-1]
        
        v = {cat: 0 for cat in CAT_LIST}
        for insn in preamble:
            cat = OPCODE_MAP.get(insn.insn.mnemonic, "Other")
            v[cat] += 1
            
        vectors.append([v[cat] for cat in CAT_LIST])
        
    print(f"  {fname}: Extracted {len(vectors)} vectors (Filter: {select_opaque_only}).")
    return vectors

def collect_from_dir(root_dir, is_obfuscated=False):
    all_vectors = []
    print(f"Scanning {root_dir}...")
    paths = [p for p in Path(root_dir).rglob("*") if p.is_file() and is_executable_elf(p)]
    
    print(f"Found {len(paths)} binaries. Sampling {MAX_BINARIES if MAX_BINARIES else 'all'}...")
    
    if len(paths) == 0:
        return np.array([])

    subset = []
    if MAX_BINARIES is None:
        subset = paths
    else:
        random.shuffle(paths)
        subset = paths[:MAX_BINARIES]
    
    for i, p in enumerate(subset):
        print(f"[{i+1}/{len(subset)}] Analyzing: {p.name}")
        # Pass the flag to filter only opaque predicates if we are in the obfuscated dir
        vecs = extract_vectors(str(p), select_opaque_only=is_obfuscated)
        if vecs:
            all_vectors.extend(vecs)
            
    return np.array(all_vectors)

if __name__ == "__main__":
    # Process Base
    vecs_base = collect_from_dir(DIR_BASE, is_obfuscated=False)
    if len(vecs_base) == 0:
        print("\nNo base vectors found.")
        exit()

    print(f"\nSuccess! Base Center calculated from {len(vecs_base)} vectors.")
    global_center = np.mean(vecs_base, axis=0)

    # Process Obfuscated
    vecs_obf = collect_from_dir(DIR_OBF, is_obfuscated=True)
    if len(vecs_obf) == 0:
        print("\nNo opaque predicates found using the signature filter.")
        exit()

    # Calculate
    print("\nCalculating distances and plotting...")
    dist_base = [distance.euclidean(v, global_center) for v in vecs_base]
    dist_obf = [distance.euclidean(v, global_center) for v in vecs_obf]

    # Plot Histograms
    fig, ax = plt.subplots(figsize=(12, 7))
    format_ax(ax)
    
    ax.hist(dist_base, bins=40, alpha=0.4, label='Unobfuskiert', 
            color=dataset_colors[0], density=True)
    ax.hist(dist_obf, bins=40, alpha=0.4, label='Obfuskiert', 
            color=dataset_colors[2], density=True)

    # Plot KDE Lines
    try:
        combined_data = dist_base + dist_obf
        x_range = np.linspace(0, max(combined_data), 1000)
        
        kde_base = gaussian_kde(dist_base)
        kde_obf = gaussian_kde(dist_obf)
        
        ax.plot(x_range, kde_base(x_range), color=dataset_line_colors[0], lw=2)
        ax.plot(x_range, kde_obf(x_range), color=dataset_line_colors[2], lw=2)
    except Exception as e:
        print(f"KDE Plot failed: {e}")

    ax.set_xlabel("Euklid'sche Distanz zum Mittelpunkt unobfuskierter Prädikate")
    ax.set_ylabel('Relative Häufigkeit')
    ax.legend()

    # Plot unobfuscated average
    avg_base = np.mean(dist_base)
    ax.axvline(avg_base, linestyle='--', color=dataset_line_colors[0],
               label=f"Unobfuskiert (Ø={avg_base:.2f})")
    
    # Plot obfuscated average
    avg_obf = np.mean(dist_obf)
    ax.axvline(avg_obf, linestyle='--', color=dataset_line_colors[2],
               label=f"Obfuskiert (Ø={avg_obf:.2f})")

    # Plot where other methods' averages lie
    # avg_other_methods = {
    #     "Bi-opake Prädikate (Threads)": 3.2,
    #     "Bi-opake Prädikate (Gleitkommazahlen)": 4.1,
    #     "Bi-opake Prädikate (Covert Propagation)": 4.5,
    #     "Bi-opake Prädikate (Covert Propagation)": 5.1,
    #     "Obfuscator-LLVM": 5.2
    # }
    
    # # Make colors distinct for these lines
    # for i, (method, avg_dist) in enumerate(avg_other_methods.items()):
    #     ax.axvline(avg_dist, linestyle='--', color=sns.color_palette("husl", len(avg_other_methods))[i],
    #                label=f"{method} (Ø={avg_dist})")
    ax.legend()

    save_path = 'output/stealth.pdf'
    plt.savefig(save_path)
    print(f"Plot saved to ./{save_path}")