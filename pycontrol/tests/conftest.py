import pytest
import random, os
import localpath

from libcpu.cpu_helper import CPUHelper
from typing import  Sequence, Iterator

from libcpu.cpu import install_backend, clear_backend
from libcpu.cpu_exec import CPUBackendControl
from libcpu.pinclient import PinClient, get_client_instance

@pytest.fixture(scope="session")
def pins_client_real() -> Iterator[PinClient]:

    client = get_client_instance()

    yield client

    shd = os.environ.get("EMU_SHUTDOWN")
    if shd is not None:
        client.shutdown()


@pytest.fixture
def cpu_backend_real(pins_client_real: PinClient) -> Iterator[CPUBackendControl]:
    backend = CPUBackendControl(pins_client_real)
    install_backend(backend)
    yield backend
    clear_backend()


@pytest.fixture(scope="module")
def random_bytes() -> Sequence[int]:
    data = []

    for addr in range(0x10000):
        value = random.randrange(256)
        data.append(value)

    return data


@pytest.fixture
def cpu_helper(pins_client_real: PinClient) -> CPUHelper:
    pins_client_real.reset()
    return CPUHelper(pins_client_real)
