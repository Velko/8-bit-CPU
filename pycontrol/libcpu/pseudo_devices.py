from abc import abstractmethod
from .markers import AddrBase
from typing import Union, Callable, Optional, List
from .devices import RAM
from .util import ControlSignal, UninitializedError
from .pinclient import PinClient

class EnableCallback(ControlSignal):
    def __init__(self, callback: Callable[[], None], original: ControlSignal) -> None:
        self.callback = callback
        self.original = original

    def enable(self) -> None:
        self.callback()


class RamHook:
    @abstractmethod
    def is_active(self) -> bool: ...

    @abstractmethod
    def invoke(self) -> None: ...

class ImmediateValue(RamHook):
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
        if self.client is None: return
        if self.write_enabled:
            self.client.bus_free()
            self.write_enabled = False

    def invoke(self) -> None:
        if self.client is None: raise UninitializedError
        if len(self.value) > 0:
            self.client.bus_set(self.value[0])
            self.write_enabled = True

    def is_active(self) -> bool:
        return len(self.value) > 0


class RamProxy:
    def __init__(self, name: str, ram: RAM) -> None:
        self.name = name
        self.ram = ram
        self.out = EnableCallback(self.enable_out, ram.out)
        self.write = EnableCallback(self.enable_write, ram.write)

        self._out_hook: Optional[RamHook] = None
        self._write_hook: Optional[RamHook] = None

    # update to intercept ram.out
    def hook_out(self, hook: RamHook) -> None:
        self._out_hook = hook

    # update to intercept ram.write
    def hook_write(self, hook: RamHook) -> None:
        self._write_hook = hook

    def enable_out(self) -> None:
        if self._out_hook is not None and self._out_hook.is_active():
            self._out_hook.invoke()
        else:
            self.ram.out.enable()

    def enable_write(self) -> None:
        if self._write_hook is not None and self._write_hook.is_active():
            self._write_hook.invoke()
        else:
            self.ram.write.enable()


Imm = ImmediateValue()
