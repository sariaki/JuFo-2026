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

# Silence CLE warnings and Angr chatter
logging.getLogger('cle').setLevel(logging.ERROR)
logging.getLogger('angr').setLevel(logging.ERROR)

DIR_BASE = "/home/paul/Documents/JuFo-2026/evaluation/llvm-test-suite-build/MultiSource"
DIR_OBF = "/home/paul/Documents/JuFo-2026/evaluation/llvm-test-suite-build_obfuscated/MultiSource"

MAX_BINARIES = 50

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
        print(f" [!] Error analyzing {file_path.name}: {e}")
        return None

def collect_from_dir(root_dir):
    print(f"Scanning {root_dir}...")
    paths = [p for p in Path(root_dir).rglob("*") if p.is_file() and is_executable_elf(p)]
    
    print(f"Found {len(paths)} binaries. Sampling {MAX_BINARIES}...")
    
    if len(paths) == 0:
        return np.array([])

    # Ensure we don't try to sample more than exist
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
    print(f"Base (Mean CC): {np.mean(base_complexities) if len(base_complexities) > 0 else 0:.2f}")
    print(f"Obfuscated (Mean CC): {np.mean(obf_complexities) if len(obf_complexities) > 0 else 0:.2f}")

    # Example Plotting (Optional)
    if len(base_complexities) > 0 and len(obf_complexities) > 0:
        plt.figure(figsize=(10, 6))
        plt.hist(base_complexities, alpha=0.5, label='Original', color=dataset_colors[0], bins=20)
        plt.hist(obf_complexities, alpha=0.5, label='Obfuscated', color=dataset_colors[2], bins=20)
        plt.title('Distribution of Average Cyclomatic Complexity')
        plt.xlabel('Avg Cyclomatic Complexity')
        plt.ylabel('Count')
        plt.legend()
        plt.show()
        plt.savefig('output/potency.pdf')
        print("Plot saved to ./output/potency.pdf")