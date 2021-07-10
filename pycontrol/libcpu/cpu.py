from typing import Optional, Union, Tuple
from abc import abstractmethod
from .util import UninitializedError
from .DeviceSetup import RegA, RegB, RegC, RegD, Flags as RegFlags
from .devices import Register, Flags
from .markers import AddrBase
from .opcodes import opcodes

class CPUBackend:
    @abstractmethod
    def execute_mnemonic(self, opcode: str, arg: Union[None, int, AddrBase]=None) -> Tuple[bool, Optional[int]]: pass

class InvalidOpcodeException(Exception):
    pass


backend: Optional[CPUBackend] = None

def install_cpu_backend(engine: CPUBackend) -> None:
    global backend
    backend = engine

A = RegA
B = RegB
C = RegC
D = RegD
F = RegFlags

def ldi(target: Union[Register, Flags], value: int) -> None:
    if backend is None: raise UninitializedError
    opcode = "ldi_{}_imm".format(target.name)
    backend.execute_mnemonic(opcode, value)

def lea(target: Union[Register], addr: AddrBase) -> None:
    if backend is None: raise UninitializedError
    opcode = "lea_{}_addr".format(target.name)
    backend.execute_mnemonic(opcode, addr)

def add(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "add_{}_{}".format(target.name, arg.name)
    backend.execute_mnemonic(opcode)

def adc(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "adc_{}_{}".format(target.name, arg.name)
    backend.execute_mnemonic(opcode)

def sub(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "sub_{}_{}".format(target.name, arg.name)
    backend.execute_mnemonic(opcode)

def sbb(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "sbb_{}_{}".format(target.name, arg.name)
    backend.execute_mnemonic(opcode)

def andb(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "and_{}_{}".format(target.name, arg.name)
    backend.execute_mnemonic(opcode)

def orb(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "or_{}_{}".format(target.name, arg.name)
    backend.execute_mnemonic(opcode)

def xor(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "xor_{}_{}".format(target.name, arg.name)
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
    opcode = "cmp_{}_{}".format(target.name, arg.name)
    backend.execute_mnemonic(opcode)

def out(source: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "out_{}".format(source.name)
    _, out_val = backend.execute_mnemonic(opcode)

    assert out_val is not None
    print ("{}".format(out_val), flush=True)

def cout(source: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "cout_{}".format(source.name)
    _, out_val = backend.execute_mnemonic(opcode)

    assert out_val is not None
    print (chr(out_val), flush=True, end="")


def mov(target: Register, source: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "mov_{}_{}".format(target.name, source.name)
    backend.execute_mnemonic(opcode)

def st(addr: AddrBase, source: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "st_addr_{}".format(source.name)
    backend.execute_mnemonic(opcode, addr)

def stx(base: AddrBase, idx_reg: Register, source: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "stx_addr_{}_{}".format(idx_reg.name, source.name)
    backend.execute_mnemonic(opcode, base)

def ldx(target: Register, base: AddrBase, idx_reg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "ldx_{}_addr_{}".format(target.name, idx_reg.name)
    backend.execute_mnemonic(opcode, base)

def tstx(base: AddrBase, idx_reg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "tstx_addr_{}".format(idx_reg.name)
    backend.execute_mnemonic(opcode, base)

def ld(target: Register, addr: AddrBase) -> None:
    if backend is None: raise UninitializedError
    opcode = "ld_{}_addr".format(target.name)
    backend.execute_mnemonic(opcode, addr)

def bcs(label: Optional[AddrBase]=None) -> bool:
    if backend is None: raise UninitializedError
    taken, _ = backend.execute_mnemonic("bcs_addr", label)
    return taken

def bcc(label: Optional[AddrBase]=None) -> bool:
    if backend is None: raise UninitializedError
    taken, _ = backend.execute_mnemonic("bcc_addr", label)
    return taken

def beq(label: Optional[AddrBase]=None) -> bool:
    if backend is None: raise UninitializedError
    taken, _ = backend.execute_mnemonic("beq_addr", label)
    return taken

def bne(label: Optional[AddrBase]=None) -> bool:
    if backend is None: raise UninitializedError
    taken, _ = backend.execute_mnemonic("bne_addr", label)
    return taken

def jmp(label: AddrBase) -> bool:
    if backend is None: raise UninitializedError
    taken, _ = backend.execute_mnemonic("jmp_addr", label)
    return taken

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
    backend.execute_mnemonic("call_addr", addr)

def ldr(target: Register, base: Register, offset: int) -> None:
    if backend is None: raise UninitializedError
    opcode = f"ldr_{target.name}_{base.name}_imm"
    backend.execute_mnemonic(opcode, offset)

def strel(base: Register, offset: int, source: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"str_{base.name}_imm_{source.name}"
    backend.execute_mnemonic(opcode, offset)

def dummy_ext(value: int) -> None:
    if backend is None: raise UninitializedError
    opcode = "dummyext_imm"
    backend.execute_mnemonic(opcode, value)
