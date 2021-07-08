import pytest
import random
import localpath

from libcpu.test_helpers import CPUHelper
from typing import Iterator, Sequence

from libcpu.pinclient import PinClient
from libcpu.cpu import install_cpu_backend
from libcpu.ctrl_word import CtrlWord
from libcpu.cpu_exec import CPUBackendControl
from libcpu.DeviceSetup import ProgMem


@pytest.fixture(scope="session")
def cpu_backend_real() -> CPUBackendControl:
    pins = PinClient()
    control = CtrlWord()
    backend = CPUBackendControl(pins, control)

    install_cpu_backend(backend)

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
    cpu_backend_real.control.reset()
    cpu_backend_real.flags_cache = None
    cpu_backend_real.opcode_cache = None
    return CPUHelper(cpu_backend_real)

@pytest.fixture
def cpu_helper_unhooked(cpu_backend_real: CPUBackendControl) -> Iterator[CPUHelper]:
    cpu_backend_real.control.reset()
    cpu_backend_real.flags_cache = None
    cpu_backend_real.opcode_cache = None
    ProgMem.unhook_all()
    yield CPUHelper(cpu_backend_real)
    cpu_backend_real.hook_progmem()
