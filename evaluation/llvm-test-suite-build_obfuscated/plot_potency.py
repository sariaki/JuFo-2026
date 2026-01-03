import os
import angr
import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path
from tqdm import tqdm
import random
import logging
import networkx as nx

dataset_colors = ['#9671bd', '#7e7e7e', '#77b5b6']
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

# Silence CLE warnings and Angr chatter
logging.getLogger('cle').setLevel(logging.ERROR)
logging.getLogger('angr').setLevel(logging.ERROR)

DIR_BASE = "/home/paul/Documents/JuFo-2026/evaluation/llvm-test-suite-build/MultiSource"
DIR_OBF = "/home/paul/Documents/JuFo-2026/evaluation/llvm-test-suite-build_obfuscated/MultiSource"

MAX_BINARIES = None

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

    
def get_binary_complexity(file_path):
    try:
        # load_options={'auto_load_libs': False} is CRITICAL for speed
        proj = angr.Project(str(file_path), load_options={'auto_load_libs': False})
        
        # Generate a fast Control Flow Graph
        cfg = proj.analyses.CFGFast(normalize=True)
        
        function_complexities = []
        
        for func in cfg.kb.functions.values():
            # Filter out PLT stubs and SimProcedures
            if func.is_plt or func.is_simprocedure:
                continue
            
            # Cyclomatic Complexity = E - N + 2
            try:
                num_edges = func.graph.number_of_edges()
                num_nodes = func.graph.number_of_nodes()
                
                # Avoid calculating on empty functions
                if num_nodes == 0:
                    continue
                    
                cc = num_edges - num_nodes + 2
                function_complexities.append(cc)
            except Exception:
                continue

        if not function_complexities:
            return None

        return np.mean(function_complexities)

    except Exception as e:
        # Printing the full traceback can be helpful if new errors appear
        print(f" Error analyzing {file_path.name}: {e}")
        return None

def collect_from_dir(root_dir):
    print(f"Scanning {root_dir}...")
    paths = [p for p in Path(root_dir).rglob("*") if p.is_file() and is_executable_elf(p)]
    
    print(f"Found {len(paths)} binaries. Sampling {MAX_BINARIES if MAX_BINARIES else 'all'}...")
    
    if len(paths) == 0:
        return np.array([])

    subset = []
    if MAX_BINARIES is None:
        subset = paths
    else:
        sample_size = min(len(paths), MAX_BINARIES)
        random.shuffle(paths)
        subset = paths[:sample_size]
    
    complexities_list = []
    
    # Using tqdm for a progress bar since analysis takes time
    for p in tqdm(subset, desc="Analyzing Binaries"):
        avg_cc = get_binary_complexity(p)
        
        if avg_cc is not None:
            complexities_list.append(avg_cc)
            
    return np.array(complexities_list)

# --- Main execution block (Example usage) ---
if __name__ == "__main__":
    print("--- Processing Base Directory ---")
    base_complexities = collect_from_dir(DIR_BASE)
    
    print("\n--- Processing Obfuscated Directory ---")
    obf_complexities = collect_from_dir(DIR_OBF)
    
    print("\n--- Results ---")
    avg_base = np.mean(base_complexities)
    avg_obf = np.mean(obf_complexities)

    print(f"Unobfuskiert (Ø=): {avg_base}")
    print(f"Obfuskiert (Ø=): {avg_obf}")

    # Plot
    if len(base_complexities) > 0 and len(obf_complexities) > 0:
        fig, ax = plt.subplots(figsize=(12, 7))
        format_ax(ax)

        ax.hist(base_complexities, alpha=0.5, label='Unobfuskiert', color=dataset_colors[0], bins=20)
        ax.hist(obf_complexities, alpha=0.5, label='Obfuskiert', color=dataset_colors[2], bins=20)

        # Plot unobfuscated average
        ax.axvline(avg_base, linestyle='--', color=dataset_line_colors[0],
                label=f"Unobfuskiert (Ø={avg_base:.2f})")
        
        # Plot obfuscated average
        ax.axvline(avg_obf, linestyle='--', color=dataset_line_colors[2],
                label=f"Obfuskiert (Ø={avg_obf:.2f})")

        ax.set_xlabel('Durchschnittliche zyklomatische Komplexität pro Funktion')
        ax.set_ylabel('Relative Häufigkeit')

        ax.legend()
        plt.savefig('output/potency.pdf')
        print("Plot saved to ./output/potency.pdf")