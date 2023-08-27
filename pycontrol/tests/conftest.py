import pytest
import random, os
import localpath

from libcpu.cpu_helper import CPUHelper
from typing import  Sequence, Iterator

from libcpu.assisted_cpu import AssistedCPU
from libcpu.pinclient import PinClient, get_client_instance

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
    def __init__(self, addresses: Sequence[int]) -> None:
        self.addresses = addresses
        self.contents = []

        for _ in range(0x10000):
            value = random.randrange(256)
            self.contents.append(value)

    def write_ram(self, client: PinClient) -> None:
        cpu_helper = CPUHelper(client)

        for addr in self.addresses:
            cpu_helper.write_ram(addr, self.contents[addr])
