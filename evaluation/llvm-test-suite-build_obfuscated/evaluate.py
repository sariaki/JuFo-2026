import json
import os
import subprocess
import shutil
import sys
from collections import defaultdict

LEVELS = [20, 40, 60, 80, 100]
NUM_RUNS = 5
BASH_SCRIPT_NAME = "./run.sh" # Replace with your actual bash script name
GENERATE_DATA = True  # if we already have the results

def run_benchmarks():
    """
    Executes the bash script for each level and run, renaming the output.
    """
    print(f"--- Starting Data Generation ({NUM_RUNS} runs per level) ---")
    
    for level in LEVELS:
        for run in range(1, NUM_RUNS + 1):
            print(f"[Level {level}] Run {run}/{NUM_RUNS}...")
            
            # Execute the user's bash script
            subprocess.run([BASH_SCRIPT_NAME, str(level)], check=False)

            # The bash script creates 'results{level}.json'. 
            # We rename it to 'results{level}_{run}.json'.
            original_output = f"results{level}.json"
            new_output = f"results{level}_{run}.json"
            
            if os.path.exists(original_output):
                shutil.move(original_output, new_output)
            else:
                print(f"Error: Expected output {original_output} not found.")
                sys.exit(1)

def average_results():
    print(f"\n--- Starting Data Averaging ---")

    for level in LEVELS:
        print(f"Processing Level {level}...")
        
        # Dictionary to store lists of values: test_name -> metric_name -> [v1, v2, v3...]
        aggregated_data = defaultdict(lambda: defaultdict(list))
        
        # We keep the structure of the first run to use as a template for the output
        template_json = None
        
        # 1. Gather Data
        files_processed = 0
        for run in range(1, NUM_RUNS + 1):
            filename = f"results{level}_{run}.json"
            
            if not os.path.exists(filename):
                print(f"  Warning: File {filename} missing. Skipping.")
                continue
                
            with open(filename, 'r') as f:
                data = json.load(f)
                
            if template_json is None:
                template_json = data

            # Iterate over tests in this specific run
            for test in data.get('tests', []):
                name = test.get('name')
                code = test.get('code')
                
                # Only average metrics if the test PASSED
                if code == 'PASS' and 'metrics' in test:
                    for metric_key, metric_val in test['metrics'].items():
                        # Lit metrics can be floats or ints. We ignore non-numeric.
                        if isinstance(metric_val, (int, float)):
                            aggregated_data[name][metric_key].append(metric_val)
            
            files_processed += 1

        if files_processed == 0:
            print(f"  No data found for Level {level}. Skipping.")
            continue

        # 2. Compute Averages
        # We modify the template_json in place
        averaged_tests = []
        
        for test in template_json.get('tests', []):
            name = test.get('name')
            
            # If we have collected data for this test
            if name in aggregated_data:
                # Calculate avg for each metric
                new_metrics = {}
                for metric_key, values in aggregated_data[name].items():
                    if values:
                        avg_val = sum(values) / len(values)
                        new_metrics[metric_key] = avg_val
                
                # Update the test object
                test['metrics'] = new_metrics
                averaged_tests.append(test)
            else:
                # If the test failed in the template or had no data, keep it as is (or exclude it)
                averaged_tests.append(test)

        template_json['tests'] = averaged_tests
        
        # 3. Write Output
        output_filename = f"averaged_results{level}.json"
        with open(output_filename, 'w') as f:
            json.dump(template_json, f, indent=2)
            
        print(f"  Saved: {output_filename}")

if __name__ == "__main__":
    # Ensure the bash script is executable
    if GENERATE_DATA:
        if not os.access(BASH_SCRIPT_NAME, os.X_OK):
            print(f"Warning: {BASH_SCRIPT_NAME} is not executable. Trying to chmod...")
            os.chmod(BASH_SCRIPT_NAME, 0o755)
        
        run_benchmarks()
        
    average_results()
    print("\nDone.")