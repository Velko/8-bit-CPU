from .pin import Pin, Level

class Register:
    def __init__(self, name, out, load, alu_a, alu_b):
        self.name = name
        self.out = out
        self.load = load
        self.alu_a = alu_a
        self.alu_b = alu_b

    def connect(self, client):
        self.out.connect(client)
        self.load.connect(client)
        self.alu_a.connect(client)
        self.alu_b.connect(client)

    def off(self):
        self.out.disable()
        self.load.disable()
        self.alu_a.disable()
        self.alu_b.disable()


class ALU:
    def __init__(self, name, out, sub):
        self.name = name
        self.out = out
        self.sub = sub

    def connect(self, client):
        self.out.connect(client)
        self.sub.connect(client)

    def off(self):
        self.out.disable()
        self.sub.disable()


class Flags:
    def __init__(self, name, load, use_carry, bus_out, bus_in):
        self.name = name
        self.load = load
        self.use_carry = use_carry
        self.bus_out = bus_out
        self.bus_in = bus_in

    def connect(self, client):
        self.load.connect(client)
        self.use_carry.connect(client)
        self.bus_out.connect(client)
        self.bus_in.connect(client)

    def off(self):
        self.load.disable()
        self.use_carry.disable()
        self.bus_out.disable()
        self.bus_in.disable()

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
