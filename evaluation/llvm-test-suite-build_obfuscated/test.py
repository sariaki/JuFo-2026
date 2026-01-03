import angr
import claripy

def solve():
    # 1. Load the binary
    # auto_load_libs=False speeds up loading by not analyzing shared libraries
    project = angr.Project('./example', auto_load_libs=False)

    # 2. Find the address of the function "foo"
    foo_symbol = project.loader.find_symbol('foo')
    if not foo_symbol:
        print("[-] Could not find symbol 'foo' in the binary.")
        return
    foo_addr = foo_symbol.rebased_addr

    # 3. Create a symbolic double (64-bit floating point)
    # FSORT_DOUBLE corresponds to the C 'double' type
    arg = claripy.FPS('arg', claripy.FSORT_DOUBLE)

    # 4. Initialize a state starting at the beginning of 'foo'
    # call_state automatically handles the calling convention (e.g., placing the arg 
    # in an XMM register on x64 or on the stack for x86)
    initial_state = project.factory.call_state(foo_addr, arg)

    # 5. Create a Simulation Manager to manage execution paths
    simgr = project.factory.simulation_manager(initial_state)

    # 6. Define the success condition
    # We check the stdout buffer (file descriptor 1) for the target string
    def is_successful(state):
        return b"FalseBB says hi" in state.posix.dumps(1)

    # 7. Explore the binary
    print(f"[+] Exploring function 'foo' at {hex(foo_addr)}...")
    simgr.explore(find=is_successful)

    # 8. Check if a solution was found and solve for the input
    if simgr.found:
        solution_state = simgr.found[0]
        # solver.eval(arg) converts the symbolic expression into a concrete Python float
        result = solution_state.solver.eval(arg)
        print(f"[+] Found matching input: {result}")
        
        # Optional: Print the full stdout of the successful state
        # print(f"Full stdout: {solution_state.posix.dumps(1).decode()}")
    else:
        print("[-] Could not find any input that results in that output.")

if __name__ == "__main__":
    solve()