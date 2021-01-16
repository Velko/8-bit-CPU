from .pin import Pin, Level

class Register:
    def __init__(self, name, pin_out, pin_load):
        self.name = name
        self.pin_out = pin_out
        self.pin_load = pin_load

    def connect(self, client):
        self.pin_out.connect(client)
        self.pin_load.connect(client)

    def out(self):
        self.pin_out.enable()

    def load(self):
        self.pin_load.enable()

    def off(self):
        self.pin_out.disable()
        self.pin_load.disable()


class ALU:
    def __init__(self, name, pin_out, pin_sub):
        self.name = name
        self.pin_out = pin_out
        self.pin_sub = pin_sub

    def connect(self, pin_client):
        self.pin_out.connect(pin_client)
        self.pin_sub.connect(pin_client)

    def out(self):
        self.pin_out.enable()

    def sub(self):
        self.pin_sub.enable()

    def off(self):
        self.pin_out.disable()
        self.pin_sub.disable()


class Flags:
    def __init__(self, pin_load, pin_use_carry, pin_bus_out, pin_bus_in):
        self.pin_load = pin_load
        self.pin_use_carry = pin_use_carry
        self.pin_bus_out = pin_bus_out
        self.pin_bus_in = pin_bus_in

    def connect(self, pin_client):
        self.pin_load.connect(pin_client)
        self.pin_use_carry.connect(pin_client)
        self.pin_bus_out.connect(pin_client)
        self.pin_bus_in.connect(pin_client)

    def load(self):
        self.pin_load.enable()

    def use_carry(self):
        self.pin_use_carry.enable()

    def off(self):
        self.pin_load.disable()
        self.pin_use_carry.disable()
        self.pin_bus_out.disable()
        self.pin_bus_in.disable()

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
