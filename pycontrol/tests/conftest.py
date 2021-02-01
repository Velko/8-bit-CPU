import pytest

from libpins.PinClient import PinClient
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
