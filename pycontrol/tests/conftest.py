import pytest
import random, os
import localpath

from libcpu.cpu_helper import CPUHelper
from typing import  Sequence, Iterator

from libcpu.cpu import setup_live
from libcpu.cpu_exec import CPUBackendControl


@pytest.fixture(scope="session")
def cpu_backend_real() -> Iterator[CPUBackendControl]:
    backend = setup_live()

    yield backend

    shd = os.environ.get("EMU_SHUTDOWN")
    if shd is not None:
        backend.client.shutdown()

@pytest.fixture(scope="module")
def random_bytes() -> Sequence[int]:
    data = []

    for addr in range(0x10000):
        value = random.randrange(256)
        data.append(value)

    return data


@pytest.fixture
def cpu_helper(cpu_backend_real: CPUBackendControl) -> CPUHelper:
    cpu_backend_real.client.reset()
    cpu_backend_real.flags_cache = None
    cpu_backend_real.opcode_cache = None
    return CPUHelper(cpu_backend_real.client)
