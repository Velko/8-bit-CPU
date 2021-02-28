import pytest, random
import localpath

from libcpu.pinclient import PinClient
from libcpu.cpu import install_cpu_backend
from libcpu.ctrl_word import CtrlWord
from libcpu.cpu_exec import CPUBackendControl


@pytest.fixture(scope="session")
def cpu_backend_real(request):
    pins = PinClient()
    control = CtrlWord()
    backend = CPUBackendControl(pins, control)

    install_cpu_backend(backend)

    return backend

@pytest.fixture(scope="module")
def random_bytes():
    data = []

    for addr in range(256):
        value = random.randrange(256)
        data.append(value)

    return data
