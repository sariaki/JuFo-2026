import angr
import claripy
import sys

def main():
    # Load the compiled binary
    project = angr.Project('./crackme2', auto_load_libs=False)

    # Define symbolic argument
    # The source code explicitly checks for a length of 16 characters.
    arg_length = 16
    sym_arg = claripy.BVS('sym_arg', arg_length * 8)

    # Setup initial state
    state = project.factory.entry_state(args=[project.filename, sym_arg])

    # Constrain the input to printable ASCII characters
    # This prevents angr from finding solutions with unprintable/weird bytes
    for i in range(arg_length):
        byte = sym_arg.get_byte(i)
        state.solver.add(byte >= 0x20) # Space character
        state.solver.add(byte <= 0x7e) # Tilde character

    # Create the Simulation Manager
    simgr = project.factory.simgr(state)

    # Define Find and Avoid conditions using standard output (stdout)
    def is_successful(state):
        stdout_output = state.posix.dumps(sys.stdout.fileno())
        return b"Ja," in stdout_output

    def is_failed(state):
        stdout_output = state.posix.dumps(sys.stdout.fileno())
        return b"Nein," in stdout_output or b"Zu viele Argumente!" in stdout_output

    # Run
    print("[*] Running symbolic execution...")
    simgr.explore(find=is_successful, avoid=is_failed)

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