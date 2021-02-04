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
        self.ram = ram
        self.out = EnableCallback(self.enable_out)
        self.write = EnableCallback(self.enable_write)

        self._ram_out = ram.out
        self._ram_write = ram.write

    # update to intercept ram.out
    def hook_out(self, hook):
        self._ram_out = hook

    # update to intercept ram.write
    def hook_write(self, hook):
        self._ram_write = hook

    def enable_out(self):
        self._ram_out.enable()

    def enable_write(self):
        self._ram_write.enable()

    def unhook_all(self):
        self._ram_out = self.ram.out
        self._ram_write = self.ram.write


Imm = ImmediateValue()
