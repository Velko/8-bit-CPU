from abc import abstractmethod
from collections.abc import Callable
from .markers import AddrBase
from .devices import RAM, DeviceBase
from .pin import ControlSignal
from .util import UninitializedError
from .pinclient import PinClient
from typing import Tuple

class EnableCallback(ControlSignal):
    def __init__(self, callback: Callable[[int], int], original: ControlSignal) -> None:
        ControlSignal.__init__(self)
        self.callback = callback
        self.original = original

    def apply_enable(self, c_word: int) -> int:
        return self.callback(c_word)


class RamHook:
    @abstractmethod
    def is_active(self) -> bool: ...

    @abstractmethod
    def invoke(self) -> None: ...

class ImmediateValue(RamHook):
    def __init__(self) -> None:
        self.client: PinClient | None = None
        self.value: list[int] = []
        self.write_enabled = False

    def connect(self, client: PinClient) -> None:
        self.client = client

    def inject(self, value: int | AddrBase | None) -> None:
        if value is None:
            self.value = []
        elif isinstance(value, int):
            self.value = [value]
        elif isinstance(value, AddrBase):
            self.value = value.a_bytes()
        else:
            raise TypeError

    def invalidate(self) -> None:
        self.value = []

    def consume(self) -> None:
        if len(self.value) > 0:
            del self.value[0]

    def release_bus(self) -> None:
        if self.client is None:
            return
        if self.write_enabled:
            self.client.bus_free()
            self.write_enabled = False

    def invoke(self) -> None:
        if self.client is None:
            raise UninitializedError
        if len(self.value) > 0:
            self.client.bus_set(self.value[0])
            self.write_enabled = True

    def is_active(self) -> bool:
        return len(self.value) > 0


class RamProxy(DeviceBase):
    def __init__(self, name: str, ram: RAM) -> None:
        DeviceBase.__init__(self, name)
        self.name = name
        self.ram = ram
        self.out = EnableCallback(self.enable_out, ram.out)
        self.write = EnableCallback(self.enable_write, ram.write)

        self._out_hook: RamHook | None = None
        self._write_hook: RamHook | None = None

    # update to intercept ram.out
    def hook_out(self, hook: RamHook) -> None:
        self._out_hook = hook

    # update to intercept ram.write
    def hook_write(self, hook: RamHook) -> None:
        self._write_hook = hook

    def enable_out(self, c_word: int) -> int:
        if self._out_hook is not None and self._out_hook.is_active():
            self._out_hook.invoke()
            return c_word

        return self.ram.out.apply_enable(c_word)

    def enable_write(self, c_word: int) -> int:
        if self._write_hook is not None and self._write_hook.is_active():
            self._write_hook.invoke()
            return c_word

        return self.ram.write.apply_enable(c_word)

def sign_extend(b: int) -> int:
    if b > 127:
        return b - 256
    return b

class IOMonitor:
    def __init__(self) -> None:
        self.selected_port: int | None = None
        self.numeric_mode = 0

    def select_port(self, port: int) -> None:
        self.selected_port = port

    def format_value(self, value: int) -> Tuple[int, str] | None:
        if self.selected_port == 1:
            self.numeric_mode = value
            return None

        if self.selected_port == 0:
            if self.numeric_mode == 0:
                return self.selected_port, f"{value:>4}\n"
            if self.numeric_mode == 1:
                return self.selected_port, f"{sign_extend(value):>4}\n"
            if self.numeric_mode == 2:
                return self.selected_port, f"h {value:02x}\n"
            if self.numeric_mode == 3:
                return self.selected_port, f"o{value:>o}\n"
        elif self.selected_port == 4:
            return self.selected_port, chr(value)

        return None



Imm = ImmediateValue()
IOMon = IOMonitor()
