
from .pinclient import PinClient
from . import cpu
from .ctrl_word import CtrlWord
from .cpu_exec import CPUBackendControl
from .cpu_assemble import CPUBackendAssemble
from .cpu_emul import CPUBackendEmulate
from .markers import InitializedBuffer
from .test_helpers import CPUHelper
from typing import Callable, Optional

control = CtrlWord()
pins: Optional[PinClient] = None

def setup_live() -> None:
    global pins
    pins = PinClient()
    backend = CPUBackendControl(pins, control)
    cpu.install_cpu_backend(backend)

def setup_data(s: InitializedBuffer) -> None:
    if not isinstance(cpu.backend, CPUBackendControl):
        raise TypeError
    helper = CPUHelper(cpu.backend)
    helper.write_data(s)

def compile(program: Callable[[], None]) -> None:
    backend = CPUBackendAssemble()
    cpu.install_cpu_backend(backend)
    program()
    backend.list()

    binary = open("sieve.bin", "wb")
    backend.bin(binary)
    binary.close()

def setup_emul() -> None:
    backend = CPUBackendEmulate()
    cpu.install_cpu_backend(backend)
