from .pin import PinBase, Level

class Register:
    def __init__(self, name: str, out: PinBase, load: PinBase, alu_a: PinBase, alu_b: PinBase):
        self.name = name
        self.out = out
        self.load = load
        self.alu_a = alu_a
        self.alu_b = alu_b

    def __str__(self):
        return self.name

    def __repr__(self):
        return self.name


class ALU:
    def __init__(self, name: str, out: PinBase, sub: PinBase):
        self.name = name
        self.out = out
        self.sub = sub


class Flags:
    def __init__(self, name: str, load: PinBase, use_carry: PinBase, bus_out: PinBase, bus_in: PinBase):
        self.name = name
        self.load = load
        self.use_carry = use_carry
        self.bus_out = bus_out
        self.bus_in = bus_in

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
    def __init__(self, name: str, out: PinBase, write: PinBase):
        self.name = name
        self.out = out
        self.write = write

class Clock:
    def __init__(self, name: str, halt: PinBase):
        self.name = name
        self.halt = halt

class StepCounter:
    def __init__(self, name: str, reset: PinBase):
        self.name = name
        self.reset = reset

class ProgramCounter:
    def __init__(self, name: str, out: PinBase, load: PinBase, count: PinBase):
        self.name = name
        self.out = out
        self.load = load
        self.count = count

    def __str__(self):
        return self.name

    def __repr__(self):
        return self.name


# Helper device for debugger
class IRFetch:
    def __init__(self, name: str, load: PinBase):
        self.name = name
        self.load = load
