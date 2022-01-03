
from .pinclient import PinClient
from . import cpu
from .ctrl_word import CtrlWord
from .cpu_exec import CPUBackendControl
from .test_helpers import CPUHelper
from typing import Optional

control = CtrlWord()
pins: Optional[PinClient] = None

def setup_live() -> CPUBackendControl:
    global pins
    pins = PinClient()
    backend = CPUBackendControl(pins, control)
    cpu.install_cpu_backend(backend)

    return backend
