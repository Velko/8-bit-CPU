from .markers import AddrBase
from .devices import RAM, DeviceBase
from .pin import Pin
from .util import sign_extend
from .pinclient import PinClient
from .messages import OutMessage

class ImmediateValue:
    def __init__(self) -> None:
        self.value: list[int] = []
        self.write_enabled = False

    def inject(self, value: int | AddrBase | bytes | None) -> None:
        if value is None:
            self.value = []
        elif isinstance(value, int):
            self.value = [value]
        elif isinstance(value, AddrBase):
            self.value = value.a_bytes()
        elif isinstance(value, bytes):
            self.value = list(value)
        else:
            raise TypeError

    def invalidate(self) -> None:
        self.value = []

    def unpublish(self, client: PinClient) -> None:
        if self.write_enabled:
            client.bus_free()
            self.write_enabled = False

    def publish(self, client: PinClient) -> None:
        if len(self.value) > 0:
            client.bus_set(self.value[0])
            self.write_enabled = True
            del self.value[0]


class IOMonitor:
    def __init__(self) -> None:
        self.selected_port: int | None = None
        self.numeric_mode = 0

    def select_port(self, port: int) -> None:
        self.selected_port = port

    def format_value(self, value: int) -> OutMessage | None:
        if self.selected_port == 1:
            self.numeric_mode = value
            return None

        if self.selected_port == 0:
            if self.numeric_mode == 0:
                return OutMessage(self.selected_port, f"{value:>4}\n")
            if self.numeric_mode == 1:
                return OutMessage(self.selected_port, f"{sign_extend(value):>4}\n")
            if self.numeric_mode == 2:
                return OutMessage(self.selected_port, f"h {value:02x}\n")
            if self.numeric_mode == 3:
                return OutMessage(self.selected_port, f"o{value:>o}\n")
        elif self.selected_port == 4:
            return OutMessage(self.selected_port, chr(value))

        return None
