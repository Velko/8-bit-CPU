from .markers import AddrBase
from .pinclient import PinClient

class ImmediateValue:
    def __init__(self, client: PinClient) -> None:
        self.value: list[int] = []
        self.write_enabled = False
        self.client = client

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

    def unpublish(self) -> None:
        if self.write_enabled:
            self.client.bus_free()
            self.write_enabled = False

    def publish(self) -> None:
        if len(self.value) > 0:
            self.client.bus_set(self.value[0])
            self.write_enabled = True
            del self.value[0]

    def has_value(self) -> bool:
        return len(self.value) > 0
