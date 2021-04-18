from .pin import PinBase, Level

class Register:
    def __init__(self, name: str, out: PinBase, load: PinBase, alu_a: PinBase, alu_b: PinBase) -> None:
        self.name = name
        self.out = out
        self.load = load
        self.alu_a = alu_a
        self.alu_b = alu_b

    def __str__(self) -> str:
        return self.name

    def __repr__(self) -> str:
        return self.name


class ALU:
    def __init__(self, name: str, out: PinBase, alt: PinBase) -> None:
        self.name = name
        self.out = out
        self.alt = alt


class Flags:
    def __init__(self, name: str, calc: PinBase, carry: PinBase, bus_out: PinBase, bus_load: PinBase) -> None:
        self.name = name
        self.calc = calc
        self.carry = carry
        self.bus_out = bus_out
        self.bus_load = bus_load

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
    def __init__(self, name: str, halt: PinBase) -> None:
        self.name = name
        self.halt = halt

class StepCounter:
    def __init__(self, name: str, reset: PinBase) -> None:
        self.name = name
        self.reset = reset

class ProgramCounter:
    def __init__(self, name: str, out: PinBase, load: PinBase, count: PinBase) -> None:
        self.name = name
        self.out = out
        self.load = load
        self.count = count

    def __str__(self) -> str:
        return self.name

    def __repr__(self) -> str:
        return self.name

class StackPointer:
    def __init__(self, name: str, out: PinBase, load: PinBase, inc: PinBase, dec: PinBase) -> None:
        self.name = name
        self.out = out
        self.load = load
        self.inc = inc
        self.dec = dec

    def __str__(self) -> str:
        return self.name

    def __repr__(self) -> str:
        return self.name

class PCLR:
    def __init__(self, name: str, swap: PinBase) -> None:
        self.name = name
        self.swap = swap

# Helper device for debugger
class IRFetch:
    def __init__(self, name: str, load: PinBase) -> None:
        self.name = name
        self.load = load
