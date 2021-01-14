class Register:
    def __init__(self, name, pin_out, pin_load):
        self.pin_client = None
        self.name = name
        self.pin_out = pin_out
        self.pin_load = pin_load

    def connect(self, pin_client):
        self.pin_client = pin_client

    def out(self):
        self.pin_client.ctrl_clr(self.pin_out)

    def load(self):
        self.pin_client.ctrl_clr(self.pin_load)

    def off(self):
        self.pin_client.ctrl_set(self.pin_out)
        self.pin_client.ctrl_set(self.pin_load)


class ALU:
    def __init__(self, name, pin_out, pin_sub):
        self.pin_client = None
        self.name = name
        self.pin_out = pin_out
        self.pin_sub = pin_sub

    def connect(self, pin_client):
        self.pin_client = pin_client

    def out(self):
        self.pin_client.ctrl_clr(self.pin_out)

    def sub(self):
        self.pin_client.ctrl_set(self.pin_sub)

    def off(self):
        self.pin_client.ctrl_set(self.pin_out)
        self.pin_client.ctrl_clr(self.pin_sub)


class Flags:
    def __init__(self, pin_load, pin_use_carry):
        self.pin_client = None
        self.pin_load = pin_load
        self.pin_use_carry = pin_use_carry

    def connect(self, pin_client):
        self.pin_client = pin_client

    def load(self):
        self.pin_client.ctrl_clr(self.pin_load)

    def use_carry(self):
        self.pin_client.ctrl_set(self.pin_use_carry)

    def off(self):
        self.pin_client.ctrl_clr(self.pin_use_carry)

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
