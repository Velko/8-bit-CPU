
from libpins.PinClient import PinClient
from . import cpu
from .ctrl_word import CtrlWord
from .cpu_exec import CPUBackendControl

pins = PinClient()
control = CtrlWord()

def setup():
    backend = CPUBackendControl(pins, control)
    cpu.install_cpu_backend(backend)
