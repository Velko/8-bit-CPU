from .pin import Pin
from .util import ControlSignal
class DeviceBase:
    def __init__(self, name: str) -> None:
        self.name = name

    def assign_pin_names(self) -> None:
        for  a_name, attr in self.__dict__.items():
            if isinstance(attr, ControlSignal):
                attr.name = f"{self.name}.{a_name}"

    def __str__(self) -> str:
        return self.name

    def __repr__(self) -> str:
        return self.name

class Register(DeviceBase):
    def __init__(self, name: str, out: Pin, load: Pin) -> None:
        DeviceBase.__init__(self, name)
        self.out = out
        self.load = load
        self.assign_pin_names()

class GPRegister(Register):
    def __init__(self, name: str, out: Pin, load: Pin, alu_l: Pin, alu_r: Pin) -> None:
        Register.__init__(self, name, out, load)
        self.alu_l = alu_l
        self.alu_r = alu_r
        self.assign_pin_names()

class WORegister(DeviceBase):
    def __init__(self, name: str, load: Pin) -> None:
        DeviceBase.__init__(self, name)
        self.load = load
        self.assign_pin_names()

class ALU(DeviceBase):
    def __init__(self, name: str, out: Pin, alt: Pin) -> None:
        DeviceBase.__init__(self, name)
        self.out = out
        self.alt = alt
        self.assign_pin_names()


class Flags(Register):
    def __init__(self, name: str, out: Pin, load: Pin, calc: Pin, carry: Pin) -> None:
        Register.__init__(self, name, out, load)
        self.calc = calc
        self.carry = carry
        self.assign_pin_names()

    V = 0b1000
    C = 0b0100
    Z = 0b0010
    N = 0b0001

    @staticmethod
    def decode(val: int) -> str:
        #VCZF
        val = int(val)

        f = ""

        if val & Flags.V:
            f += 'V'
        else:
            f += '-'

        if val & Flags.C:
            f += 'C'
        else:
            f += '-'

        if val & Flags.Z:
            f += 'Z'
        else:
            f += '-'

        if val & Flags.N:
            f += 'N'
        else:
            f += '-'

        return f

class RAM(DeviceBase):
    def __init__(self, name: str, out: Pin, write: Pin) -> None:
        DeviceBase.__init__(self, name)
        self.out = out
        self.write = write
        self.assign_pin_names()

class Clock(DeviceBase):
    def __init__(self, name: str, halt: Pin, brk: Pin) -> None:
        DeviceBase.__init__(self, name)
        self.halt = halt
        self.brk  = brk
        self.assign_pin_names()

class StepCounter(DeviceBase):
    def __init__(self, name: str, reset: Pin, extended: Pin) -> None:
        DeviceBase.__init__(self, name)
        self.reset = reset
        self.extended = extended
        self.assign_pin_names()

class AddressRegister(Register):
    def __init__(self, name: str, out: Pin, load: Pin) -> None:
        Register.__init__(self, name, out, load)

class ProgramCounter(AddressRegister):
    def __init__(self, name: str, out: Pin, load: Pin, inc: Pin) -> None:
        AddressRegister.__init__(self, name, out, load)
        # To save on control lines, in current setup PC increment and output operations
        # are merged, PC increments whenever it outputs and there's a clock tick.
        # 2 aliased operations are defined to better describe intent in microcode.
        self.inc = inc
        self.assign_pin_names()

class StackPointer(AddressRegister):
    def __init__(self, name: str, out: Pin, load: Pin, inc: Pin, dec: Pin) -> None:
        AddressRegister.__init__(self, name, out, load)
        self.inc = inc
        self.dec = dec
        self.assign_pin_names()

class TransferRegister(Register):
    def __init__(self, name: str, out: Pin, load: Pin) -> None:
        Register.__init__(self, name, out, load)

class AddressCalculator(Register):
    def __init__(self, name: str, out: Pin, load: Pin, signed: Pin) -> None:
        Register.__init__(self, name, out, load)
        self.signed = signed
        self.assign_pin_names()

class IOController(DeviceBase):
    def __init__(self, name: str, laddr: Pin, from_dev: Pin, to_dev: Pin) -> None:
        DeviceBase.__init__(self, name)
        self.laddr = laddr
        self.from_dev = from_dev
        self.to_dev = to_dev
        self.assign_pin_names()
