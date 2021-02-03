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

    def enable_out(self):
        if self.value is not None:
            self.client.bus_set(self.value)
            self.write_enabled = True


class RamProxy:
    def __init__(self, name, ram):
        self.name = name
        self.out = EnableCallback(self.enable_out)
        self.write = ram.write

        # Replace the ram_out with another EnableCallback
        # to intercept
        self.ram_out = ram.out

    def enable_out(self):
        self.ram_out.enable()


Imm = ImmediateValue()
