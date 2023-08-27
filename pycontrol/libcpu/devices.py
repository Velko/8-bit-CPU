from typing import Any
from dataclasses import dataclass
from .pin import Pin
from .util import ControlSignal

@dataclass
class DeviceBase:
    name: str

    def __setattr__(self, name: str, value: Any) -> None:
        if isinstance(value, ControlSignal):
            value.name = f"{self.name}.{name}"
        super().__setattr__(name, value)

    def __str__(self) -> str:
        return self.name

@dataclass
class Register(DeviceBase):
    out: Pin
    load: Pin

@dataclass
class GPRegister(Register):
    alu_l: Pin
    alu_r: Pin

@dataclass
class WORegister(DeviceBase):
    load: Pin

@dataclass
class ALU(DeviceBase):
    out: Pin
    alt: Pin


@dataclass
class Flags(Register):
    calc: Pin
    carry: Pin

    V = 0b1000
    C = 0b0100
    Z = 0b0010
    N = 0b0001


    @staticmethod
    def decode(val: int) -> str:

        def fls(condition: int, c: str) -> str:
            if condition:
                return c
            return '-'

        val = int(val)

        #VCZN
        return f"{fls( val & Flags.V, 'V')}"\
               f"{fls( val & Flags.C, 'C')}"\
               f"{fls( val & Flags.Z, 'Z')}"\
               f"{fls( val & Flags.N, 'N')}"

@dataclass
class RAM(DeviceBase):
    out: Pin
    write: Pin

@dataclass
class Clock(DeviceBase):
    halt: Pin
    brk: Pin

@dataclass
class StepCounter(DeviceBase):
    reset: Pin
    extended: Pin

@dataclass
class AddressRegister(Register):
    pass

@dataclass
class ProgramCounter(AddressRegister):
    inc: Pin

@dataclass
class StackPointer(AddressRegister):
    inc: Pin
    dec: Pin

@dataclass
class TransferRegister(Register):
    pass

@dataclass
class AddressCalculator(Register):
    signed: Pin

@dataclass
class IOController(DeviceBase):
    laddr: Pin
    from_dev: Pin
    to_dev: Pin
