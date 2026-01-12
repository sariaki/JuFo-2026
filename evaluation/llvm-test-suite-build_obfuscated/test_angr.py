import angr
import claripy

def solve():
    project = angr.Project('./example_old', auto_load_libs=False)

    foo_symbol = project.loader.find_symbol('foo')
    if not foo_symbol:
        print("[-] Could not find symbol 'foo' in binary.")
        return
    foo_addr = foo_symbol.rebased_addr

    arg = claripy.BVS('arg', 64)

    initial_state = project.factory.call_state(
        foo_addr, 
        arg, 
        # Add options to simplify solving and save memory
        add_options={
            angr.options.ZERO_FILL_UNCONSTRAINED_MEMORY, 
            angr.options.ZERO_FILL_UNCONSTRAINED_REGISTERS
        }
    )

    simgr = project.factory.simulation_manager(initial_state)

    # Use 'LengthLimiter' alongside DFS.
    # This forces angr to abandon paths that get too deep (ex: infinite loops).
    simgr.use_technique(angr.exploration_techniques.DFS())
    simgr.use_technique(angr.exploration_techniques.LengthLimiter(max_length=1000, drop=True))

    FALSE_BB_ADDR = project.loader.main_object.min_addr + 0x16B1
    TRUE_BB_ADDR = project.loader.main_object.min_addr + 0x168A

    # Cleanup function to free memory.
    def cleanup_memory(simgr):
        if len(simgr.avoid) > 0:
            simgr.drop(stash='avoid')
        if len(simgr.deadended) > 0:
            simgr.drop(stash='deadended')
        return simgr

    print(f"[+] Exploring function 'foo' at {hex(foo_addr)}...")

    # Pass the cleanup function to step_func
    simgr.explore(find=[TRUE_BB_ADDR], step_func=cleanup_memory)

    if simgr.found:
        for solution_state in simgr.found:
            print("-------------------")
            try:
                result = solution_state.solver.eval(arg)
                output = solution_state.posix.dumps(1).decode(errors='ignore')
                print(f"[+] Found matching input: {result}")
                print(f"Full stdout: {output}")
            except Exception as e:
                print(f"[-] Error evaluating solution: {e}")
    else:
        # Check 'errored' stash to see if something crashed during simulation
        if simgr.errored:
            print(f"[-] Exploration finished with {len(simgr.errored)} errors.")
            print(simgr.errored[0])
        else:
            print("[-] Could not find any input that results in that output.")

if __name__ == "__main__":
    solve()