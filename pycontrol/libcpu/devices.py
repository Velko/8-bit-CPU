from .pin import PinBase

class Register:
    def __init__(self, name: str, out: PinBase, load: PinBase) -> None:
        self.name = name
        self.out = out
        self.load = load

    def __str__(self) -> str:
        return self.name

    def __repr__(self) -> str:
        return self.name


class GPRegister(Register):
    def __init__(self, name: str, out: PinBase, load: PinBase, alu_l: PinBase, alu_r: PinBase) -> None:
        Register.__init__(self, name, out, load)
        self.alu_l = alu_l
        self.alu_r = alu_r

class ALU:
    def __init__(self, name: str, out: PinBase, alt: PinBase) -> None:
        self.name = name
        self.out = out
        self.alt = alt


class Flags(Register):
    def __init__(self, name: str, out: PinBase, load: PinBase, calc: PinBase, carry: PinBase) -> None:
        Register.__init__(self, name, out, load)
        self.calc = calc
        self.carry = carry

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

class RAM:
    def __init__(self, name: str, out: PinBase, write: PinBase) -> None:
        self.name = name
        self.out = out
        self.write = write

class Clock:
    def __init__(self, name: str, halt: PinBase, brk: PinBase) -> None:
        self.name = name
        self.halt = halt
        self.brk  = brk

class StepCounter:
    def __init__(self, name: str, reset: PinBase, extended: PinBase) -> None:
        self.name = name
        self.reset = reset
        self.extended = extended

class ProgramCounter(Register):
    def __init__(self, name: str, out: PinBase, load: PinBase, inc: PinBase) -> None:
        Register.__init__(self, name, out, load)
        # To save on control lines, in current setup PC increment and output operations
        # are merged, PC increments whenever it outputs and there's a clock tick.
        # 2 aliased operations are defined to better describe intent in microcode.
        self.inc = self.out

class StackPointer(Register):
    def __init__(self, name: str, out: PinBase, load: PinBase, inc: PinBase, dec: PinBase) -> None:
        Register.__init__(self, name, out, load)
        self.inc = inc
        self.dec = dec

    def __str__(self) -> str:
        return self.name

    def __repr__(self) -> str:
        return self.name

class TransferRegister(Register):
    def __init__(self, name: str, out: PinBase, load: PinBase) -> None:
        Register.__init__(self, name, out, load)

class AddressCalculator(Register):
    def __init__(self, name: str, out: PinBase, load: PinBase) -> None:
        Register.__init__(self, name, out, load)

