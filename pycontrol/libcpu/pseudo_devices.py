from .markers import AddrBase
from typing import Union, Callable, Optional, List
from .devices import RAM
from .util import ControlSignal, UninitializedError
from .pinclient import PinClient

class EnableCallback(ControlSignal):
    def __init__(self, callback: Callable[[], None]) -> None:
        self.callback = callback

    def enable(self) -> None:
        self.callback()


class ImmediateValue:
    def __init__(self) -> None:
        self.client: Optional[PinClient] = None
        self.value: List[int] = []
        self.write_enabled = False

    def connect(self, client: PinClient) -> None:
        self.client = client

    def set(self, value: Union[None, int, AddrBase]) -> None:
        if value is None:
            self.value = []
        elif isinstance(value, int):
            self.value = [value]
        elif isinstance(value, AddrBase):
            self.value = value.a_bytes()
        else:
            raise TypeError

    def clear(self) -> None:
        self.value = []

    def consume(self) -> None:
        if len(self.value) > 0:
            del self.value[0]

    def disable(self) -> None:
        if self.client is None: raise UninitializedError
        if self.write_enabled:
            self.client.bus_free()
            self.write_enabled = False

    def enable_out(self) -> None:
        if self.client is None: raise UninitializedError
        if len(self.value) > 0:
            self.client.bus_set(self.value[0])
            self.write_enabled = True


class RamProxy:
    def __init__(self, name: str, ram: RAM) -> None:
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
