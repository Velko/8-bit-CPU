import pytest
import random
import localpath

from libcpu.test_helpers import CPUHelper
from typing import  Sequence

from libcpu.cpu import setup_live
from libcpu.cpu_exec import CPUBackendControl


@pytest.fixture(scope="session")
def cpu_backend_real() -> CPUBackendControl:
    backend = setup_live()

    return backend

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
    cpu_backend_real.control.reset()
    cpu_backend_real.flags_cache = None
    cpu_backend_real.opcode_cache = None
    return CPUHelper(cpu_backend_real)
