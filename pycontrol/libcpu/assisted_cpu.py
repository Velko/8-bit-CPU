from typing import Optional, Union, overload
from .util import RunMessage
from .devices import GPRegister, Flags, FlagsRegister, AddressRegister
from .markers import AddrBase
from .pinclient import PinClient
from .assisted_cpu_engine import AssistedCPUEngine

class AssistedCPU(AssistedCPUEngine):
    def __init__(self, client: PinClient) -> None:
        AssistedCPUEngine.__init__(self, client)

    @overload
    def ldi(self, target: GPRegister, value: int) -> None:
        ...

    @overload
    def ldi(self, target: FlagsRegister, value: Flags) -> None:
        ...

    def ldi(self, target: Union[GPRegister, FlagsRegister], value: int | Flags ) -> None:
        opcode = f"ldi_{target.name}_imm"
        if isinstance(value, Flags):
            value = value.value
        self.execute_mnemonic(opcode, value)

    def lea(self, target: AddressRegister, addr: AddrBase) -> None:
        opcode = f"lea_{target.name}_addr"
        self.execute_mnemonic(opcode, addr)

    def add(self, target: GPRegister, arg: GPRegister) -> None:
        opcode = f"add_{target.name}_{arg.name}"
        self.execute_mnemonic(opcode)

    def adc(self, target: GPRegister, arg: GPRegister) -> None:
        opcode = f"adc_{target.name}_{arg.name}"
        self.execute_mnemonic(opcode)

    def sub(self, target: GPRegister, arg: GPRegister) -> None:
        opcode = f"sub_{target.name}_{arg.name}"
        self.execute_mnemonic(opcode)

    def sbb(self, target: GPRegister, arg: GPRegister) -> None:
        opcode = f"sbb_{target.name}_{arg.name}"
        self.execute_mnemonic(opcode)

    def andb(self, target: GPRegister, arg: GPRegister) -> None:
        opcode = f"and_{target.name}_{arg.name}"
        self.execute_mnemonic(opcode)

    def orb(self, target: GPRegister, arg: GPRegister) -> None:
        opcode = f"or_{target.name}_{arg.name}"
        self.execute_mnemonic(opcode)

    def xor(self, target: GPRegister, arg: GPRegister) -> None:
        opcode = f"xor_{target.name}_{arg.name}"
        self.execute_mnemonic(opcode)

    def clr(self, arg: GPRegister) -> None:
        opcode = f"clr_{arg.name}"
        self.execute_mnemonic(opcode)

    def notb(self, target: GPRegister) -> None:
        opcode = f"not_{target.name}"
        self.execute_mnemonic(opcode)

    def shr(self, target: GPRegister) -> None:
        opcode = f"shr_{target.name}"
        self.execute_mnemonic(opcode)

    def ror(self, target: GPRegister) -> None:
        opcode = f"ror_{target.name}"
        self.execute_mnemonic(opcode)

    def asr(self, target: GPRegister) -> None:
        opcode = f"asr_{target.name}"
        self.execute_mnemonic(opcode)

    def swap(self, target: GPRegister) -> None:
        opcode = f"swap_{target.name}"
        self.execute_mnemonic(opcode)

    def inc(self, target: GPRegister) -> None:
        opcode = f"inc_{target.name}"
        self.execute_mnemonic(opcode)

    def dec(self, target: GPRegister) -> None:
        opcode = f"dec_{target.name}"
        self.execute_mnemonic(opcode)

    def cmp(self, target: GPRegister, arg: GPRegister) -> None:
        opcode = f"cmp_{target.name}_{arg.name}"
        self.execute_mnemonic(opcode)

    def mov(self, target: GPRegister, source: GPRegister) -> None:
        opcode = f"mov_{target.name}_{source.name}"
        self.execute_mnemonic(opcode)

    def st(self, addr: AddrBase, source: GPRegister) -> None:
        opcode = f"st_addr_{source.name}"
        self.execute_mnemonic(opcode, addr)

    def stx(self, base: AddrBase, idx_reg: GPRegister, source: GPRegister) -> None:
        opcode = f"stx_addr_{idx_reg.name}_{source.name}"
        self.execute_mnemonic(opcode, base)

    def ldx(self, target: GPRegister, base: AddrBase, idx_reg: GPRegister) -> None:
        opcode = f"ldx_{target.name}_addr_{idx_reg.name}"
        self.execute_mnemonic(opcode, base)

    def tstx(self, base: AddrBase, idx_reg: GPRegister) -> None:
        opcode = f"tstx_addr_{idx_reg.name}"
        self.execute_mnemonic(opcode, base)

    def ld(self, target: GPRegister, addr: AddrBase) -> None:
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

    def push(self, source: GPRegister | AddressRegister) -> None:
        opcode = f"push_{source.name}"
        self.execute_mnemonic(opcode)

    def pop(self, target: GPRegister | AddressRegister) -> None:
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

    def ldr(self, target: GPRegister, base: AddressRegister, offset: int) -> None:
        opcode = f"ldr_{target.name}_{base.name}_imm"
        self.execute_mnemonic(opcode, offset)

    def strel(self, base: AddressRegister, offset: int, source: GPRegister) -> None:
        opcode = f"str_{base.name}_imm_{source.name}"
        self.execute_mnemonic(opcode, offset)

    def out(self, port: int, source: GPRegister) -> Optional[RunMessage]:
        opcode = f"out_imm_{source.name}"
        return self.execute_mnemonic(opcode, port)

    def dummy_ext(self, value: int) -> None:
        opcode = "dummyext_imm"
        self.execute_mnemonic(opcode, value)
