import pytest
import random
import os
from dataclasses import dataclass

from libcpu.cpu_helper import CPUHelper
from collections.abc import  Sequence, Iterator, Iterable

from libcpu.assisted_cpu import AssistedCPU
from libcpu.pinclient import PinClient, get_client_instance
from libcpu.devices import DeviceBase

@pytest.fixture(scope="session")
def pins_client_real() -> Iterator[PinClient]:

    client = get_client_instance()

    yield client

    shd = os.environ.get("EMU_SHUTDOWN")
    if shd is not None:
        client.shutdown()


@pytest.fixture
def acpu(pins_client_real: PinClient) -> AssistedCPU:
    return AssistedCPU(pins_client_real)


@pytest.fixture
def cpu_helper(pins_client_real: PinClient) -> CPUHelper:
    pins_client_real.reset()
    return CPUHelper(pins_client_real)


class FillRam:
    def __init__(self, addresses: Sequence[int], values: Iterable[int] | None = None) -> None:

        if values is None:
            values = FillRam.random_bytes()

        self.contents = dict(zip(addresses, values))

    @staticmethod
    def random_bytes() -> Iterator[int]:
        while True:
            yield random.randrange(256)

    def write_ram(self, client: PinClient) -> None:
        cpu_helper = CPUHelper(client)

        for addr, value in self.contents.items():
            cpu_helper.write_ram(addr, value)

def devname(reg: DeviceBase) -> str:
    return f"{reg.name} "

@dataclass
class ALUTwoRegTestCase:
    name: str
    val_a: int
    val_b: int
    result: int
    xflags: str

    def __str__(self) -> str:
        return f"{self.name}: ({self.val_a}, {self.val_b}) -> ({self.result}, {self.xflags}) "

@dataclass
class ALUOneRegTestCase:
    name: str
    val: int
    result: int
    xflags: str

    def __str__(self) -> str:
        return f"{self.name}: ({self.val}) -> ({self.result}, {self.xflags}) "
