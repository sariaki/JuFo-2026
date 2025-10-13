import angr
import claripy

proj = angr.Project(
    r"example.exe",
    load_options={
        "main_opts": {"backend": "pe", "debug_symbols": r"example.pdb"},
    },
    auto_load_libs=False,
)

base = proj.loader.main_object.min_addr
foo_va = base + 0x72D0
int3_va = foo_va + 0xb8
int3_good_va = foo_va + 0xbe

# create a symbolic argument sized to the target arch
input_arg = claripy.BVS("arg", proj.arch.bits)

# build a call-state at foo and inject the symbolic value into the first
# Windows x64 calling register (RCX) or the right register for arch automatically
state = proj.factory.call_state(foo_va, 0)   # create a proper call frame
# overwrite the first argument register with our symbolic value
state.regs.rcx = input_arg

simgr = proj.factory.simgr(state)
simgr.explore(find=int3_good_va)
if simgr.found:
    input_value = simgr.found[0].solver.eval(input_arg)
    print(f"Value of input_arg that reaches BAD: {input_value}")

    constraints = simgr.found[0].solver.constraints
    print(constraints)
    solver = claripy.Solver()
    solver.add(constraints)
    # print(solver.min(input_arg))
    # print(solver.max(input_arg))
    # print(simgr.found[0].ip)
else:
    print("No path found that reaches real branch.")