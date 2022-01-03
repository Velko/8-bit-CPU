
from .pinclient import PinClient
from . import cpu
from .ctrl_word import CtrlWord
from .cpu_exec import CPUBackendControl
from .test_helpers import CPUHelper
from typing import Optional

def setup_live() -> CPUBackendControl:
    backend = CPUBackendControl()
    cpu.install_cpu_backend(backend)

    return backend
