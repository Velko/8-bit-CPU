from typing import Optional, Union
from .util import UninitializedError, RunMessage
from .DeviceSetup import RegA, RegB, RegC, RegD, Flags as RegFlags
from .devices import Register, Flags
from .markers import AddrBase
from .opcodes import opcodes
from .cpu_exec import CPUBackendControl, InvalidOpcodeException

backend: Optional[CPUBackendControl] = None

def setup_live() -> CPUBackendControl:
    global backend
    backend = CPUBackendControl()

    return backend

A = RegA
B = RegB
C = RegC
D = RegD
F = RegFlags

def ldi(target: Union[Register, Flags], value: int) -> None:
    if backend is None: raise UninitializedError
    opcode = f"ldi_{target.name}_imm"
    backend.execute_mnemonic(opcode, value)

def lea(target: Register, addr: AddrBase) -> None:
    if backend is None: raise UninitializedError
    opcode = f"lea_{target.name}_addr"
    backend.execute_mnemonic(opcode, addr)

def add(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"add_{target.name}_{arg.name}"
    backend.execute_mnemonic(opcode)

def adc(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"adc_{target.name}_{arg.name}"
    backend.execute_mnemonic(opcode)

def sub(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"sub_{target.name}_{arg.name}"
    backend.execute_mnemonic(opcode)

def sbb(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"sbb_{target.name}_{arg.name}"
    backend.execute_mnemonic(opcode)

def andb(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"and_{target.name}_{arg.name}"
    backend.execute_mnemonic(opcode)

def orb(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"or_{target.name}_{arg.name}"
    backend.execute_mnemonic(opcode)

def xor(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"xor_{target.name}_{arg.name}"
    backend.execute_mnemonic(opcode)

def clr(arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"clr_{arg.name}"
    backend.execute_mnemonic(opcode)

def notb(target: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"not_{target.name}"
    backend.execute_mnemonic(opcode)

def shr(target: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"shr_{target.name}"
    backend.execute_mnemonic(opcode)

def ror(target: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"ror_{target.name}"
    backend.execute_mnemonic(opcode)

def asr(target: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"asr_{target.name}"
    backend.execute_mnemonic(opcode)

def swap(target: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"swap_{target.name}"
    backend.execute_mnemonic(opcode)

def inc(target: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"inc_{target.name}"
    backend.execute_mnemonic(opcode)

def dec(target: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"dec_{target.name}"
    backend.execute_mnemonic(opcode)

def cmp(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"cmp_{target.name}_{arg.name}"
    backend.execute_mnemonic(opcode)

def mov(target: Register, source: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"mov_{target.name}_{source.name}"
    backend.execute_mnemonic(opcode)

def st(addr: AddrBase, source: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"st_addr_{source.name}"
    backend.execute_mnemonic(opcode, addr)

def stx(base: AddrBase, idx_reg: Register, source: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"stx_addr_{idx_reg.name}_{source.name}"
    backend.execute_mnemonic(opcode, base)

def ldx(target: Register, base: AddrBase, idx_reg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"ldx_{target.name}_addr_{idx_reg.name}"
    backend.execute_mnemonic(opcode, base)

def tstx(base: AddrBase, idx_reg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"tstx_addr_{idx_reg.name}"
    backend.execute_mnemonic(opcode, base)

def ld(target: Register, addr: AddrBase) -> None:
    if backend is None: raise UninitializedError
    opcode = f"ld_{target.name}_addr"
    backend.execute_mnemonic(opcode, addr)

def bcs(label: Optional[AddrBase]=None) -> None:
    if backend is None: raise UninitializedError
    backend.execute_mnemonic("bcsl_addr", label)

def bcc(label: Optional[AddrBase]=None) -> None:
    if backend is None: raise UninitializedError
    backend.execute_mnemonic("bccl_addr", label)

def beq(label: Optional[AddrBase]=None) -> None:
    if backend is None: raise UninitializedError
    backend.execute_mnemonic("beql_addr", label)

def bne(label: Optional[AddrBase]=None) -> None:
    if backend is None: raise UninitializedError
    backend.execute_mnemonic("bnel_addr", label)

def jmp(label: AddrBase) -> None:
    if backend is None: raise UninitializedError
    backend.execute_mnemonic("ljmp_addr", label)

def rjmp(offset: int) -> None:
    if backend is None: raise UninitializedError
    backend.execute_mnemonic("rjmp_imm", offset)

def hlt() -> None:
    if backend is None: raise UninitializedError
    backend.execute_mnemonic("hlt")

def opcode_of(instr: str) -> int:
    if not instr in opcodes:
        raise InvalidOpcodeException(instr)
    return opcodes[instr].opcode

def push(source: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"push_{source.name}"
    backend.execute_mnemonic(opcode)

def pop(target: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"pop_{target.name}"
    backend.execute_mnemonic(opcode)

def pushf() -> None:
    if backend is None: raise UninitializedError
    backend.execute_mnemonic("pushf")

def popf() -> None:
    if backend is None: raise UninitializedError
    backend.execute_mnemonic("popf")

def ret() -> None:
    if backend is None: raise UninitializedError
    backend.execute_mnemonic("ret")

def call(addr: AddrBase) -> None:
    if backend is None: raise UninitializedError
    backend.execute_mnemonic("callf_addr", addr)

def ldr(target: Register, base: Register, offset: int) -> None:
    if backend is None: raise UninitializedError
    opcode = f"ldr_{target.name}_{base.name}_imm"
    backend.execute_mnemonic(opcode, offset)

def strel(base: Register, offset: int, source: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"str_{base.name}_imm_{source.name}"
    backend.execute_mnemonic(opcode, offset)

def out(port: int, source: Register) -> Optional[RunMessage]:
    if backend is None: raise UninitializedError
    opcode = f"out_imm_{source.name}"
    return backend.execute_mnemonic(opcode, port)

def dummy_ext(value: int) -> None:
    if backend is None: raise UninitializedError
    opcode = "dummyext_imm"
    backend.execute_mnemonic(opcode, value)
