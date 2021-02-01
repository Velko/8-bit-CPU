from .markers import Bytes

class EnableCallback:
    def __init__(self, callback):
        self.callback = callback

    def enable(self):
        self.callback()


class ImmediateValue:
    def __init__(self):
        self.client = None
        self.value = None
        self.out = self
        self.write_enabled = False

    def connect(self, client):
        self.client = client

    def set(self, value):
        if isinstance(value, int) or value is None:
            self.value = value
        elif isinstance(value, Bytes):
            self.value = value.start
        else:
            raise TypeError

    def clear(self):
        self.value = None

    def disable(self):
        if self.write_enabled:
            self.client.bus_free()
            self.write_enabled = False

    def enable(self):
        if self.value is not None:
            self.client.bus_set(self.value)
            self.write_enabled = True


class ResultValue:
    def __init__(self):
        self.client = None
        self.value = None
        self.active = False
        self.load = self

    def connect(self, client):
        self.client = client

    def enable(self):
        self.active = True

    def disable(self):
        self.active = False

    def read_bus(self):
        self.value = self.client.bus_get()

class ProgramCounter:
    def __init__(self):
        self.value = 0
        self.c_enabled = False
        self.out = self
        self.count = EnableCallback(self.enable_count)
        self.load  = EnableCallback(self.enable_load)

    def connect(self, client):
        pass

    def enable_count(self):
        self.c_enabled = True

    def enable_load(self):
        pass

    def enable(self):
        # OUT enable
        pass

    def disable(self):
        self.c_enabled = False

    def advance(self):
        self.value += 1

# to emulate ProgMAR
class NullRegister:
    def __init__(self):
        self.load = self

    def enable(self):
        pass



Imm = ImmediateValue()
OutPort = ResultValue()
PC = ProgramCounter()

# MAR to access program memory, normally same as regular MAR, Null in emulated mode
ProgMAR = NullRegister()

# Memory output when loading from program memory. Normally RAM or ROM, internal Imm for emulated
ProgMem = Imm