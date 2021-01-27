
import serial

from . import asm
from .PinClient import PinClient
from .cpu import CPU
from .ctrl_word import CtrlWord

ser = serial.Serial("/dev/ttyACM0", 115200, timeout=3)
pins = PinClient(ser)
cpu = CPU(pins, CtrlWord())


def setup(scope):
    # PySerial is not ready directly after connecting
    # try a single operation before proceeding with tests
    pins.identify()
    asm.export_isa(cpu, scope)

