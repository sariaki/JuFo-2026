import sys
import lief
# Added OPCODE to imports
from triton import TritonContext, ARCH, Instruction, MemoryAccess, CPUSIZE, MODE, OPCODE

def main():
    # 1. Setup the Context
    ctx = TritonContext()
    ctx.setArchitecture(ARCH.X86_64)
    ctx.setMode(MODE.ALIGNED_MEMORY, True)

    target_binary = "./example"
    print(f"[+] Loading {target_binary}...")
    binary = lief.parse(target_binary)
    
    if binary is None:
        print(f"[-] Failed to parse {target_binary}")
        return

    base_addr = 0x400000

    # 2. Map binary segments
    for segment in binary.segments:
        if segment.type == lief.ELF.Segment.TYPE.LOAD:
            va = base_addr + segment.virtual_address
            content = bytearray(segment.content)
            if len(content) < segment.physical_size:
                content += b'\x00' * (segment.physical_size - len(content))
            ctx.setConcreteMemoryAreaValue(va, content)

    # 3. Locate Symbol 'foo'
    foo_sym = binary.get_symbol("foo")
    if not foo_sym:
        print("[-] Could not find symbol 'foo'")
        return

    foo_addr = base_addr + foo_sym.value
    FALSE_BB_ADDR = base_addr + 0x16B1 

    print(f"[+] Exploring function 'foo' at {hex(foo_addr)}...")

    # 4. Setup State
    ctx.setConcreteRegisterValue(ctx.registers.rsp, 0x7fffffff)
    ctx.setConcreteRegisterValue(ctx.registers.rbp, 0x7fffffff)
    
    # Initialize argument (Concrete 0, Symbolic 'arg')
    ctx.setConcreteRegisterValue(ctx.registers.rdi, 0x00) 
    arg_sym = ctx.symbolizeRegister(ctx.registers.rdi, "arg")

    # 5. Emulation Loop
    pc = foo_addr
    count = 0
    limit = 1000

    while count < limit:
        # Fetch & Decode
        opcode_bytes = ctx.getConcreteMemoryAreaValue(pc, 16)
        op = Instruction()
        op.setOpcode(opcode_bytes)
        op.setAddress(pc)
        
        # Symbolic Execution
        try:
            ctx.processing(op)
        except Exception as e:
            print(f"[-] Crash processing instruction at {hex(pc)}: {e}")
            break
        
        # Check Target
        if pc == FALSE_BB_ADDR:
            print("-------------------")
            print(f"[+] Reached Target Address: {hex(FALSE_BB_ADDR)}")
            pco = ctx.getPathConstraints()
            model = ctx.getModel(pco)
            if model:
                for k, v in model.items():
                    sym_var = ctx.getSymbolicVariable(k)
                    if sym_var.getAlias() == "arg":
                        print(f"[+] Found matching input: {hex(v.getValue())}")
            else:
                print("[-] Path is unreachable (UNSAT).")
            break

        # Check for Return (FIXED LINE)
        # We use OPCODE.X86.RET to detect the return instruction
        if op.getType() == OPCODE.X86.RET:
            print("[-] Function returned without hitting target.")
            print("    (Note: This simple script follows a linear path. If the target")
            print("     requires a specific branch, you must implement branch handling.)")
            break

        # Next Instruction
        pc = ctx.getConcreteRegisterValue(ctx.registers.rip)
        count += 1

if __name__ == "__main__":
    main()