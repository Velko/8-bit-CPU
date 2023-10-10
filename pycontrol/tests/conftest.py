import pytest
import random
import os
import localpath
localpath.install()

from libcpu.cpu_helper import CPUHelper
from typing import  Sequence, Iterator, Optional, Iterable

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
    def __init__(self, addresses: Sequence[int], values: Optional[Iterable[int]]=None) -> None:

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
