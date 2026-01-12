import json
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import numpy as np
import os

# Styling and Setup

script_dir = os.path.dirname(os.path.abspath(__file__))
os.chdir(script_dir)
os.makedirs("output", exist_ok=True)

dataset_colors = ['#9671bd', '#7e7e7e', '#77b5b6']
dataset_line_colors = ['#6a408d', '#4e4e4e', '#378d94']

# Style settings suitable for academic papers (Single column figures)
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
    'figure.autolayout': True # Helps prevent clipping
})

def format_ax(ax):
    ax.grid(True, which='major', linestyle='-', linewidth=0.75, alpha=0.25)
    ax.minorticks_on()
    ax.grid(True, which='minor', linestyle='-', linewidth=0.25, alpha=0.15)
    ax.set_axisbelow(True)

# Data Processing

files = {
    0:   'results0.json',
    20:  'averaged_results20.json',
    40:  'averaged_results40.json',
    60:  'averaged_results60.json',
    80:  'averaged_results80.json',
    100: 'averaged_results100.json'
}

data_rows = []

print("Loading data...")
for level, filename in files.items():
    if not os.path.exists(filename):
        print(f"  [!] {filename} not found, skipping.")
        continue
        
    with open(filename, 'r') as f:
        try:
            content = json.load(f)
            tests = content.get('tests', [])
            for test in tests:
                metrics = test.get('metrics', {})
                data_rows.append({
                    'Level': level,
                    'Test': test.get('name', 'unknown'),
                    'Status': test.get('code', 'FAIL'),
                    'Size': metrics.get('size', np.nan),
                    'ExecTime': metrics.get('exec_time', np.nan),
                    'CompileTime': metrics.get('compile_time', np.nan)
                })
        except json.JSONDecodeError:
            print(f"  [!] Error decoding {filename}")

df = pd.DataFrame(data_rows)

# Normalize against Level 0 (Baseline)
baseline_df = df[df['Level'] == 0][['Test', 'Size', 'ExecTime', 'CompileTime']].copy()
baseline_df.columns = ['Test', 'BaseSize', 'BaseExec', 'BaseCompile']
df_merged = pd.merge(df, baseline_df, on='Test', how='left')

df_merged['NormSize'] = df_merged['Size'] / df_merged['BaseSize']
df_merged['NormExec'] = df_merged['ExecTime'] / df_merged['BaseExec']
df_merged['NormCompile'] = df_merged['CompileTime'] / df_merged['BaseCompile']

# Pass Rates
pass_rates = df.groupby('Level')['Status'].apply(lambda x: (x == 'PASS').mean() * 100).reset_index()
levels_list = sorted(list(files.keys()))

# Binary Size
fig, ax = plt.subplots(figsize=(6, 5))
format_ax(ax)

sns.boxplot(
    x='Level', y='NormSize', data=df_merged, ax=ax,
    color=dataset_colors[2], linecolor="#000000",
    width=0.5, showfliers=False
)
# Add Baseline Line
ax.axhline(1.0, color=dataset_line_colors[1], linestyle='--', linewidth=1.5, alpha=0.8)
# ax.text(4.5, 1.02, 'Baseline (1.0)', color=dataset_line_colors[1], fontsize=10, ha='right')

ax.set_ylabel("Normalisierte Größe")
ax.set_xlabel("Obfuskationslevel (%)")

fig.savefig("output/size.pdf")
print("Saved output/size.pdf")
plt.close()


# Execution Time
fig, ax = plt.subplots(figsize=(6, 5))
format_ax(ax)

# Only use passing tests for performance stats
perf_data = df_merged[df_merged['Status'] == 'PASS']

sns.boxplot(
    x='Level', y='NormExec', data=perf_data, ax=ax,
    color=dataset_colors[0], linecolor="#000000",
    width=0.5, showfliers=False
)
ax.axhline(1.0, color=dataset_line_colors[1], linestyle='--', linewidth=1.5, alpha=0.8)
# ax.text(4.5, 1.02, 'Baseline (1.0)', color=dataset_line_colors[1], fontsize=10, ha='right')

ax.set_ylabel("Normalisierte Laufzeit")
ax.set_xlabel("Obfuskationslevel (%)")

fig.savefig("output/runtime.pdf")
print("Saved output/runtime.pdf")
plt.close()

# Compilation Time
fig, ax = plt.subplots(figsize=(6, 5))
format_ax(ax)

# Aggregate for line plot
comp_stats = df_merged.groupby('Level')['CompileTime'].agg(['mean', 'sem']).reset_index()

# ax.errorbar(
#     comp_stats['Level'], comp_stats['mean'], yerr=comp_stats['sem'],
#     fmt='-o', 
#     color=dataset_line_colors[1],
#     markerfacecolor=dataset_colors[1],
#     markeredgecolor='white',
#     markeredgewidth=1.5,
#     markersize=9,
#     capsize=5, 
#     linewidth=2
# )

# ax.fill_between(
#     comp_stats['Level'], 
#     comp_stats['mean'] - comp_stats['sem'], 
#     comp_stats['mean'] + comp_stats['sem'],
#     color=dataset_colors[1],
#     alpha=0.3,
#     zorder=1
# )

y_low = (comp_stats['mean'] - comp_stats['sem']).min()
y_high = (comp_stats['mean'] + comp_stats['sem']).max()

pad = 0.05 * (y_high - y_low)   # 5% padding
ax.set_ylim(y_low - pad, y_high + pad)

ax.plot(
    comp_stats['Level'], comp_stats['mean'],
    '-o', 
    color=dataset_line_colors[1],
    markerfacecolor=dataset_colors[1],
    markeredgecolor='white',
    markeredgewidth=1,
    markersize=8,
    linewidth=2,
    zorder=2
)

ax.axhline(comp_stats['mean'][0], color=dataset_line_colors[1], linestyle='--', linewidth=1.5, alpha=0.8)


# bars = ax.bar(
#     [str(x) for x in comp_stats['Level']], 
#     comp_stats['mean'],
#     color=dataset_colors[1], 
#     edgecolor=dataset_line_colors[1],
#     linewidth=1.5,
#     width=0.6,
#     zorder=3
# )

# Labels on bars
# ax.bar_label(bars, fmt='%.1f', padding=4, fontsize=11, fontweight='bold')

# ax.set_xticks(levels_list)
ax.set_ylabel("Durchschnittliche Kompilationszeit (Sek.)")
ax.set_xlabel("Obfuskationslevel (%)")

fig.savefig("output/compilation_time.pdf")
print("Saved output/compilation_time.pdf")
plt.close()


# Pass Rate
fig, ax = plt.subplots(figsize=(6, 5))
format_ax(ax)

bars = ax.bar(
    [str(x) for x in pass_rates['Level']], 
    pass_rates['Status'],
    color=dataset_colors[2], 
    edgecolor=dataset_line_colors[2],
    linewidth=1.5,
    width=0.6,
    zorder=3
)

ax.set_ylabel("LLVM Testbestehungsrate (%)")
ax.set_xlabel("Obfuskationslevel (%)")
ax.set_ylim(0, 110)

# Labels on bars
for bar in bars:
    height = bar.get_height()
    ax.text(
        bar.get_x() + bar.get_width() / 2.0, 
        height + 2, 
        f'{height:.1f}%', 
        ha='center', va='bottom', fontsize=11, color='black',
        fontweight='bold'
    )

fig.savefig("output/pass_rate.pdf")
print("Saved output/pass_rate.pdf")
plt.close()