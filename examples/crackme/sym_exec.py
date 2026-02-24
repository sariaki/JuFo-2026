import angr
import claripy
import sys

def main():
    # 1. Load the compiled binary 
    # (Make sure to compile your C code first: gcc crackme.c -o crackme)
    project = angr.Project('./crackme2', auto_load_libs=False)

    # 2. Define the symbolic argument
    # The source code explicitly checks for a length of 16 characters.
    arg_length = 16
    sym_arg = claripy.BVS('sym_arg', arg_length * 8)

    # 3. Setup the initial state
    # argv[0] = ./crackme, argv[1] = our 16-byte symbolic variable
    state = project.factory.entry_state(args=[project.filename, sym_arg])

    # 4. Constrain the input to printable ASCII characters
    # This prevents angr from finding solutions with unprintable/weird bytes
    for i in range(arg_length):
        byte = sym_arg.get_byte(i)
        state.solver.add(byte >= 0x20) # Space character
        state.solver.add(byte <= 0x7e) # Tilde character

    # 5. Create the Simulation Manager
    simgr = project.factory.simgr(state)

    # 6. Define Find and Avoid conditions using standard output (stdout)
    # Instead of hardcoding memory addresses, we check what the program prints.
    def is_successful(state):
        stdout_output = state.posix.dumps(sys.stdout.fileno())
        return b"Yes," in stdout_output

    def is_failed(state):
        stdout_output = state.posix.dumps(sys.stdout.fileno())
        return b"No," in stdout_output or b"Need exactly" in stdout_output

    # 7. Run the exploration
    print("[*] Running symbolic execution...")
    simgr.explore(find=is_successful, avoid=is_failed)

    # 8. Extract the solution
    if simgr.found:
        found_state = simgr.found[0]
        
        # Evaluate the symbolic variable into a concrete string
        solution = found_state.solver.eval(sym_arg, cast_to=bytes)
        
        print(f"[+] Solution found!")
        print(f"[+] Password: {solution.decode('utf-8')}")
        
    else:
        print("[-] No solution found.")

if __name__ == '__main__':
    main()