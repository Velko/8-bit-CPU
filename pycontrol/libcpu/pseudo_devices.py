from .markers import Bytes, Label
from typing import Union, Callable
from .devices import RAM
from .util import ControlSignal, UninitializedError
from .pinclient import PinClient

class EnableCallback(ControlSignal):
    def __init__(self, callback: Callable[[], None]):
        self.callback = callback

    def enable(self) -> None:
        self.callback()


class ImmediateValue:
    def __init__(self):
        self.client = None
        self.value = None
        self.write_enabled = False

    def connect(self, client: PinClient) -> None:
        self.client = client

    def set(self, value: Union[None, int, Bytes, Label]) -> None:
        if isinstance(value, int) or value is None:
            self.value = value
        elif isinstance(value, Bytes):
            self.value = value.start
        elif isinstance(value, Label):
            self.value = value.addr
        else:
            raise TypeError

    def clear(self) -> None:
        self.value = None

    def disable(self) -> None:
        if self.client is None: raise UninitializedError
        if self.write_enabled:
            self.client.bus_free()
            self.write_enabled = False

    def enable_out(self) -> None:
        if self.client is None: raise UninitializedError
        if self.value is not None:
            self.client.bus_set(self.value)
            self.write_enabled = True


class RamProxy:
    def __init__(self, name: str, ram: RAM):
        self.name = name
        self.ram = ram
        self.out = EnableCallback(self.enable_out)
        self.write = EnableCallback(self.enable_write)

        self._ram_out: ControlSignal = ram.out
        self._ram_write: ControlSignal = ram.write

    # update to intercept ram.out
    def hook_out(self, hook: EnableCallback) -> None:
        self._ram_out = hook

    # update to intercept ram.write
    def hook_write(self, hook: EnableCallback) -> None:
        self._ram_write = hook

    def enable_out(self) -> None:
        self._ram_out.enable()

    def enable_write(self) -> None:
        self._ram_write.enable()

    def unhook_all(self) -> None:
        self._ram_out = self.ram.out
        self._ram_write = self.ram.write


Imm = ImmediateValue()
