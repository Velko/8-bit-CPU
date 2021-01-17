from .pin import Pin, Level

class Register:
    def __init__(self, name, out, load, alu_a, alu_b):
        self.name = name
        self.out = out
        self.load = load
        self.alu_a = alu_a
        self.alu_b = alu_b

    def all_pins(self):
        return [self.out, self.load, self.alu_a, self.alu_b]


class ALU:
    def __init__(self, name, out, sub):
        self.name = name
        self.out = out
        self.sub = sub

    def all_pins(self):
        return [self.out, self.sub]


class Flags:
    def __init__(self, name, load, use_carry, bus_out, bus_in):
        self.name = name
        self.load = load
        self.use_carry = use_carry
        self.bus_out = bus_out
        self.bus_in = bus_in

    def all_pins(self):
        return [self.load, self.use_carry, self.bus_out, self.bus_in]

    @staticmethod
    def decode(val):
        #VCZF
        val = int(val)

        f = ""

        if val & 0b1000:
            f += 'V'
        else:
            f += '-'

        if val & 0b0100:
            f += 'C'
        else:
            f += '-'

        if val & 0b0010:
            f += 'Z'
        else:
            f += '-'

        if val & 0b0001:
            f += 'N'
        else:
            f += '-'

        return f
