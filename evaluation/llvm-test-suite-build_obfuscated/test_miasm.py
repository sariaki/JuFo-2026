#!/usr/bin/env python3
import sys
from collections import deque
from elftools.elf.elffile import ELFFile
from z3 import BitVec, Solver, sat

_container = None
_machine = None
_symbexec_engine_type = None

_import_errors = []

try:
    from miasm.analysis.binary import Container
    from miasm.analysis.machine import Machine
    # Symbolic engine path may vary; try common names below
    _container = Container
    _machine = Machine
except Exception as e:
    _import_errors.append(("analysis.binary / analysis.machine", e))

# Older packaging paths
if _container is None or _machine is None:
    try:
        # older miasm sometimes exposes Container in miasm.core.binary
        from miasm.core.binary import Container as CoreContainer
        from miasm.core.machine import Machine as CoreMachine
        _container = CoreContainer
        _machine = CoreMachine
    except Exception as e:
        _import_errors.append(("core.binary / core.machine", e))

# Try to find a symbolic execution engine class
if _container is not None:
    # Many installs have miasm.ir.symbexec
    try:
        # common name
        from miasm.ir.symbexec import SymbexecEngine as SymbolicExecutionEngine
        _symbexec_engine_type = SymbolicExecutionEngine
    except Exception:
        try:
            from miasm.ir.symbexec import SymbExecEngine as SymbolicExecutionEngine
            _symbexec_engine_type = SymbolicExecutionEngine
        except Exception:
            try:
                # fallback: some versions use lower-level naming
                from miasm.ir.symbexec import SymbolicExecutionEngine
                _symbexec_engine_type = SymbolicExecutionEngine
            except Exception as e:
                _import_errors.append(("ir.symbexec", e))

# If any of the core imports failed, print diagnostics and exit.
if _container is None or _machine is None or _symbexec_engine_type is None:
    print("[-] Could not import miasm with a known API automatically.")
    print("Tried these attempts (showing exception summaries):")
    for name, exc in _import_errors:
        print(f"  - {name}: {type(exc).__name__}: {exc}")
    print()
    print("Please run:\n  python -c 'import miasm; import inspect; print(miasm); print(dir(miasm))'\n")
    print("and paste the printed output here (or paste the full traceback from this script).")
    sys.exit(1)

def find_symbol_addr(path, symname):
    with open(path, "rb") as f:
        elffile = ELFFile(f)
        for section in elffile.iter_sections():
            if not hasattr(section, "iter_symbols"):
                continue
            for sym in section.iter_symbols():
                if sym.name == symname:
                    return sym.entry.st_value
    return None

class PathState:
    def __init__(self, pc, symstate, path_len=0, stdout_bytes=b""):
        self.pc = pc
        self.symstate = symstate
        self.path_len = path_len
        self.stdout_bytes = stdout_bytes

def solve(binary_path, func_name="foo", max_depth=1000):
    foo_addr = find_symbol_addr(binary_path, func_name)
    if foo_addr is None:
        print(f"[-] Could not find symbol '{func_name}' in binary.")
        return
    print(f"[+] Found {func_name} at 0x{foo_addr:x}")

    # Load binary container / machine (API adapted from import success above)
    try:
        container = _container.from_stream(open(binary_path, "rb"))
    except Exception as e:
        # Some Container classes use different constructors
        try:
            container = _container(open(binary_path, "rb"))
        except Exception as e2:
            print("[-] Failed to construct Container from binary with both attempts:")
            print("  attempt1:", e)
            print("  attempt2:", e2)
            return

    try:
        machine = _machine(container.platform)
    except Exception:
        try:
            # some machines expect container (different APIs)
            machine = _machine(container)
        except Exception as e:
            print("[-] Could not construct Machine from Container:", e)
            return

    # Build a 64-bit symbolic variable for the argument (like claripy.BVS('arg',64))
    arg = BitVec("arg", 64)

    # Create a symbolic-engine instance (API widely varies)
    try:
        sym_engine = _symbexec_engine_type(machine)
    except Exception:
        try:
            # Some constructors take the container as well
            sym_engine = _symbexec_engine_type(machine, container)
        except Exception as e:
            print("[-] Could not instantiate symbolic engine:", e)
            return

    # Try to create an initial symbolic state. The exact API will differ.
    try:
        # Common API: new_state() or create_sym_state() or SymbolicState(...)
        if hasattr(sym_engine, "new_state"):
            symstate0 = sym_engine.new_state()
        elif hasattr(sym_engine, "create_state"):
            symstate0 = sym_engine.create_state()
        else:
            # fallback attempt: call the class for a fresh state
            symstate0 = getattr(sym_engine, "__call__", None) and sym_engine()
            if symstate0 is None:
                raise RuntimeError("No obvious constructor for fresh symbolic state in this sym_engine.")
    except Exception as e:
        print("[-] Could not obtain an initial symbolic state from the symbolic engine.")
        print("    Exception:", e)
        print("    You will need to adapt the code here to your miasm version's symbexec API.")
        return

    # Try to set register for the first argument (x86_64: rdi).
    # Different SymState APIs provide either dict-like .regs or set_register(name, value).
    arg_reg_name = "rdi"
    assigned_arg = False
    try:
        # attempt 1: dictionary-like
        if hasattr(symstate0, "regs") and arg_reg_name in getattr(symstate0, "regs"):
            symstate0.regs[arg_reg_name] = arg
            assigned_arg = True
    except Exception:
        pass

    if not assigned_arg:
        try:
            if hasattr(symstate0, "set_register"):
                symstate0.set_register(arg_reg_name, arg)
                assigned_arg = True
        except Exception:
            pass

    if not assigned_arg:
        # as a last resort try attribute-like (symstate0.rdi = ...)
        try:
            setattr(symstate0, arg_reg_name, arg)
            assigned_arg = True
        except Exception:
            assigned_arg = False

    if not assigned_arg:
        print("[!] Could not place the symbolic 'arg' into the initial state automatically.")
        print("    Please adapt the code where the script writes the 'arg' variable into the function's argument register.")
        return

    # Set PC on the initial state (try multiple setters)
    try:
        if hasattr(symstate0, "pc"):
            symstate0.pc = foo_addr
        elif hasattr(symstate0, "set_pc"):
            symstate0.set_pc(foo_addr)
        else:
            # Some engines require a method to relocate
            raise RuntimeError("No settable PC attribute/method on symstate0.")
    except Exception as e:
        print("[-] Could not set initial PC on the symbolic state:", e)
        return

    # Prepare DFS
    stack = [PathState(pc=foo_addr, symstate=symstate0, path_len=0, stdout_bytes=b"")]
    FALSE_BB_ADDR = foo_addr + 0x16B1  # adjust for PIE/loadbase if needed
    solutions = []
    visited = 0

    print(f"[+] Starting DFS to find 0x{FALSE_BB_ADDR:x} (max depth {max_depth})...")
    # NOTE: stepping the symbolic state requires calling whatever step API the sym_engine provides.
    # We'll use a very generic call name and instruct how to adapt if it fails.
    while stack:
        node = stack.pop()
        visited += 1
        if node.path_len > max_depth:
            continue

        # Attempt to step the state. Different miasm versions use different names:
        # - sym_engine.step(state) -> returns list of (pc, new_state, stdout_bytes)
        # - sym_engine.symbolize_and_step(state) ...
        next_infos = None
        try:
            if hasattr(sym_engine, "step"):
                next_infos = sym_engine.step(node.symstate, node.pc)
            elif hasattr(sym_engine, "step_basicblock"):
                next_infos = sym_engine.step_basicblock(node.symstate, node.pc)
            elif hasattr(sym_engine, "exec_bb"):
                next_infos = sym_engine.exec_bb(node.symstate, node.pc)
            else:
                raise RuntimeError("No known stepping API found on sym_engine.")
        except Exception as e:
            print("[!] Stepping failed with the sym_engine stepping API used.")
            print("    Exception:", e)
            print("    You should adapt this part to your miasm symbexec API (look for step/exec methods).")
            return

        # Normalize next_infos to an iterable of (next_pc, new_state, stdout_bytes)
        # Many APIs return different shapes. If it's None or empty, just continue.
        if not next_infos:
            continue

        for info in next_infos:
            # try to unpack in multiple possible formats
            try:
                next_pc, new_state, new_stdout = info
            except Exception:
                # maybe info is (next_pc, new_state)
                try:
                    next_pc, new_state = info
                    new_stdout = b""
                except Exception:
                    # unknown tuple format; skip
                    continue

            total_stdout = node.stdout_bytes + (new_stdout or b"")

            if next_pc == FALSE_BB_ADDR:
                # try to extract path constraints; API varies greatly
                try:
                    if hasattr(new_state, "get_path_constraints"):
                        path_constraints = new_state.get_path_constraints()
                    elif hasattr(new_state, "path_constraints"):
                        path_constraints = new_state.path_constraints
                    else:
                        path_constraints = []
                        print("[!] Could not auto-extract path constraints for this miasm version.")
                        print("    You will need to collect branch constraints while stepping.")
                except Exception:
                    path_constraints = []
                # Solve with Z3
                solver = Solver()
                for c in path_constraints:
                    try:
                        solver.add(c)
                    except Exception:
                        # cannot add constraints in raw form: ignore for now
                        pass
                solver.add(arg >= 0, arg <= (2**64 - 1))
                if solver.check() == sat:
                    model = solver.model()
                    concrete_arg = model[arg].as_long()
                    solutions.append((concrete_arg, total_stdout))
                else:
                    # no solution on this path
                    pass
                continue

            # push next path for DFS
            stack.append(PathState(pc=next_pc, symstate=new_state, path_len=node.path_len + 1, stdout_bytes=total_stdout))

    # end DFS
    if solutions:
        for arg_val, out in solutions:
            print("-------------------")
            print(f"[+] Found matching input: {arg_val}")
            print(f"Captured stdout: {out.decode('latin-1', errors='ignore')}")
    else:
        print("[-] No solutions found (or symbolic engine didn't expose constraints).")
    print(f"[+] Visited {visited} nodes.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 test_miasm_compat.py <binary> [function_name]")
        sys.exit(1)
    binary = sys.argv[1]
    fn = sys.argv[2] if len(sys.argv) > 2 else "foo"
    solve(binary, func_name=fn, max_depth=1000)