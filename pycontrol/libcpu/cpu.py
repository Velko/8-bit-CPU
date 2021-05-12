from typing import Optional, Union, Tuple
from abc import abstractmethod
from .util import UninitializedError
from .DeviceSetup import RegA, RegB, RegC, RegD, Flags as RegFlags
from .devices import Register, Flags
from .markers import AddrBase
from .opcodes import opcodes

class CPUBackend:
    @abstractmethod
    def execute_opcode(self, opcode: str, arg: Union[None, int, AddrBase]=None) -> Tuple[bool, Optional[int]]: pass

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
    backend.execute_opcode(opcode, value)

def add(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "add_{}_{}".format(target.name, arg.name)
    backend.execute_opcode(opcode)

def adc(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "adc_{}_{}".format(target.name, arg.name)
    backend.execute_opcode(opcode)

def sub(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "sub_{}_{}".format(target.name, arg.name)
    backend.execute_opcode(opcode)

def sbb(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "sbb_{}_{}".format(target.name, arg.name)
    backend.execute_opcode(opcode)

def andb(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "and_{}_{}".format(target.name, arg.name)
    backend.execute_opcode(opcode)

def orb(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "or_{}_{}".format(target.name, arg.name)
    backend.execute_opcode(opcode)

def xor(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "xor_{}_{}".format(target.name, arg.name)
    backend.execute_opcode(opcode)

def notb(target: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"not_{target.name}"
    backend.execute_opcode(opcode)

def shr(target: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"shr_{target.name}"
    backend.execute_opcode(opcode)

def ror(target: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"ror_{target.name}"
    backend.execute_opcode(opcode)

def asr(target: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"asr_{target.name}"
    backend.execute_opcode(opcode)

def swap(target: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"swap_{target.name}"
    backend.execute_opcode(opcode)

def inc(target: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"inc_{target.name}"
    backend.execute_opcode(opcode)

def dec(target: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"dec_{target.name}"
    backend.execute_opcode(opcode)

def cmp(target: Register, arg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "cmp_{}_{}".format(target.name, arg.name)
    backend.execute_opcode(opcode)

def out(source: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "out_{}".format(source.name)
    _, out_val = backend.execute_opcode(opcode)

    assert out_val is not None
    print ("{}".format(out_val), flush=True)

def mov(target: Register, source: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "mov_{}_{}".format(target.name, source.name)
    backend.execute_opcode(opcode)

def st(addr: AddrBase, source: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "st_addr_{}".format(source.name)
    backend.execute_opcode(opcode, addr)

def stabs(addr_reg: Register, source: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "stabs_{}_{}".format(addr_reg.name, source.name)
    backend.execute_opcode(opcode)

def ldabs(target: Register, addr_reg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "ldabs_{}_{}".format(target.name, addr_reg.name)
    backend.execute_opcode(opcode)

def tstabs(addr_reg: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = "tstabs_{}".format(addr_reg.name)
    backend.execute_opcode(opcode)

def ld(target: Register, addr: AddrBase) -> None:
    if backend is None: raise UninitializedError
    opcode = "ld_{}_addr".format(target.name)
    backend.execute_opcode(opcode, addr)

def bcs(label: Optional[AddrBase]=None) -> bool:
    if backend is None: raise UninitializedError
    taken, _ = backend.execute_opcode("bcs_addr", label)
    return taken

def bcc(label: Optional[AddrBase]=None) -> bool:
    if backend is None: raise UninitializedError
    taken, _ = backend.execute_opcode("bcc_addr", label)
    return taken

def beq(label: Optional[AddrBase]=None) -> bool:
    if backend is None: raise UninitializedError
    taken, _ = backend.execute_opcode("beq_addr", label)
    return taken

def bne(label: Optional[AddrBase]=None) -> bool:
    if backend is None: raise UninitializedError
    taken, _ = backend.execute_opcode("bne_addr", label)
    return taken

def jmp(label: AddrBase) -> bool:
    if backend is None: raise UninitializedError
    taken, _ = backend.execute_opcode("jmp_addr", label)
    return taken

def hlt() -> None:
    if backend is None: raise UninitializedError
    backend.execute_opcode("hlt")

def opcode_of(instr: str) -> int:
    if backend is None: raise UninitializedError
    if not instr in opcodes:
        raise InvalidOpcodeException(instr)
    return opcodes[instr].opcode

def push(source: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"push_{source.name}"
    backend.execute_opcode(opcode)

def pop(target: Register) -> None:
    if backend is None: raise UninitializedError
    opcode = f"pop_{target.name}"
    backend.execute_opcode(opcode)

def ret() -> None:
    if backend is None: raise UninitializedError
    backend.execute_opcode("ret")

def call(addr: AddrBase) -> None:
    if backend is None: raise UninitializedError
    backend.execute_opcode("call_addr", addr)
