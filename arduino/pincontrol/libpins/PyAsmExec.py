
import serial, os

from . import asm
from .PinClient import PinClient
from .cpu import CPU
from .ctrl_word import CtrlWord

def find_serial_port():
    ports = list(filter(lambda fn: fn.startswith("ttyACM") or fn.startswith("ttyUSB"),  os.listdir("/dev")))

    if len(ports) > 1:
        raise Exception("Multiple USB serial devices found")

    if len(ports) == 0:
        raise Exception("No USB serial devices found")

    return os.path.join("/dev", ports[0])

ser = serial.Serial(find_serial_port(), 115200, timeout=3)
pins = PinClient(ser)
cpu = CPU(pins, CtrlWord())


def setup(scope):
    # PySerial is not ready directly after connecting
    # try a single operation before proceeding with tests
    pins.identify()
    asm.export_isa(cpu, scope)

