from typing import Optional, Union
from .util import RunMessage
from .DeviceSetup import RegA, RegB, RegC, RegD, Flags as RegFlags
from .devices import Register, Flags
from .markers import AddrBase
from .pinclient import PinClient
from .assisted_cpu_engine import AssistedCPUEngine

A = RegA
B = RegB
C = RegC
D = RegD
F = RegFlags

class AssistedCPU(AssistedCPUEngine):
    def __init__(self, client: PinClient) -> None:
        AssistedCPUEngine.__init__(self, client)

    def ldi(self, target: Union[Register, Flags], value: int) -> None:
        opcode = f"ldi_{target.name}_imm"
        self.execute_mnemonic(opcode, value)

    def lea(self, target: Register, addr: AddrBase) -> None:
        opcode = f"lea_{target.name}_addr"
        self.execute_mnemonic(opcode, addr)

    def add(self, target: Register, arg: Register) -> None:
        opcode = f"add_{target.name}_{arg.name}"
        self.execute_mnemonic(opcode)

    def adc(self, target: Register, arg: Register) -> None:
        opcode = f"adc_{target.name}_{arg.name}"
        self.execute_mnemonic(opcode)

    def sub(self, target: Register, arg: Register) -> None:
        opcode = f"sub_{target.name}_{arg.name}"
        self.execute_mnemonic(opcode)

    def sbb(self, target: Register, arg: Register) -> None:
        opcode = f"sbb_{target.name}_{arg.name}"
        self.execute_mnemonic(opcode)

    def andb(self, target: Register, arg: Register) -> None:
        opcode = f"and_{target.name}_{arg.name}"
        self.execute_mnemonic(opcode)

    def orb(self, target: Register, arg: Register) -> None:
        opcode = f"or_{target.name}_{arg.name}"
        self.execute_mnemonic(opcode)

    def xor(self, target: Register, arg: Register) -> None:
        opcode = f"xor_{target.name}_{arg.name}"
        self.execute_mnemonic(opcode)

    def clr(self, arg: Register) -> None:
        opcode = f"clr_{arg.name}"
        self.execute_mnemonic(opcode)

    def notb(self, target: Register) -> None:
        opcode = f"not_{target.name}"
        self.execute_mnemonic(opcode)

    def shr(self, target: Register) -> None:
        opcode = f"shr_{target.name}"
        self.execute_mnemonic(opcode)

    def ror(self, target: Register) -> None:
        opcode = f"ror_{target.name}"
        self.execute_mnemonic(opcode)

    def asr(self, target: Register) -> None:
        opcode = f"asr_{target.name}"
        self.execute_mnemonic(opcode)

    def swap(self, target: Register) -> None:
        opcode = f"swap_{target.name}"
        self.execute_mnemonic(opcode)

    def inc(self, target: Register) -> None:
        opcode = f"inc_{target.name}"
        self.execute_mnemonic(opcode)

    def dec(self, target: Register) -> None:
        opcode = f"dec_{target.name}"
        self.execute_mnemonic(opcode)

    def cmp(self, target: Register, arg: Register) -> None:
        opcode = f"cmp_{target.name}_{arg.name}"
        self.execute_mnemonic(opcode)

    def mov(self, target: Register, source: Register) -> None:
        opcode = f"mov_{target.name}_{source.name}"
        self.execute_mnemonic(opcode)

    def st(self, addr: AddrBase, source: Register) -> None:
        opcode = f"st_addr_{source.name}"
        self.execute_mnemonic(opcode, addr)

    def stx(self, base: AddrBase, idx_reg: Register, source: Register) -> None:
        opcode = f"stx_addr_{idx_reg.name}_{source.name}"
        self.execute_mnemonic(opcode, base)

    def ldx(self, target: Register, base: AddrBase, idx_reg: Register) -> None:
        opcode = f"ldx_{target.name}_addr_{idx_reg.name}"
        self.execute_mnemonic(opcode, base)

    def tstx(self, base: AddrBase, idx_reg: Register) -> None:
        opcode = f"tstx_addr_{idx_reg.name}"
        self.execute_mnemonic(opcode, base)

    def ld(self, target: Register, addr: AddrBase) -> None:
        opcode = f"ld_{target.name}_addr"
        self.execute_mnemonic(opcode, addr)

    def bcs(self, label: Optional[AddrBase]=None) -> None:
        self.execute_mnemonic("bcsl_addr", label)

    def bcc(self, label: Optional[AddrBase]=None) -> None:
        self.execute_mnemonic("bccl_addr", label)

    def beq(self, label: Optional[AddrBase]=None) -> None:
        self.execute_mnemonic("beql_addr", label)

    def bne(self, label: Optional[AddrBase]=None) -> None:
        self.execute_mnemonic("bnel_addr", label)

    def jmp(self, label: AddrBase) -> None:
        self.execute_mnemonic("ljmp_addr", label)

    def rjmp(self, offset: int) -> None:
        self.execute_mnemonic("rjmp_imm", offset)

    def hlt(self) -> None:
        self.execute_mnemonic("hlt")

    def push(self, source: Register) -> None:
        opcode = f"push_{source.name}"
        self.execute_mnemonic(opcode)

    def pop(self, target: Register) -> None:
        opcode = f"pop_{target.name}"
        self.execute_mnemonic(opcode)

    def pushf(self) -> None:
        self.execute_mnemonic("pushf")

    def popf(self) -> None:
        self.execute_mnemonic("popf")

    def ret(self) -> None:
        self.execute_mnemonic("ret")

    def call(self, addr: AddrBase) -> None:
        self.execute_mnemonic("callf_addr", addr)

    def ldr(self, target: Register, base: Register, offset: int) -> None:
        opcode = f"ldr_{target.name}_{base.name}_imm"
        self.execute_mnemonic(opcode, offset)

    def strel(self, base: Register, offset: int, source: Register) -> None:
        opcode = f"str_{base.name}_imm_{source.name}"
        self.execute_mnemonic(opcode, offset)

    def out(self, port: int, source: Register) -> Optional[RunMessage]:
        opcode = f"out_imm_{source.name}"
        return self.execute_mnemonic(opcode, port)

    def dummy_ext(self, value: int) -> None:
        opcode = "dummyext_imm"
        self.execute_mnemonic(opcode, value)
