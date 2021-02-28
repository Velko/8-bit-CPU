
from .pinclient import PinClient
from . import cpu
from .ctrl_word import CtrlWord
from .cpu_exec import CPUBackendControl
from .cpu_assemble import CPUBackendAssemble


control = CtrlWord()
pins = None

def setup_live():
    global pins
    pins = PinClient()
    backend = CPUBackendControl(pins, control)
    cpu.install_cpu_backend(backend)

def compile(program):
    backend = CPUBackendAssemble(control)
    cpu.install_cpu_backend(backend)
    program()
    backend.list()

    binary = open("sieve.bin", "wb")
    backend.bin(binary)
    binary.close()
