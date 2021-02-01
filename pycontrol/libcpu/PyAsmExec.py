
from libpins.PinClient import PinClient
from . import cpu
from .ctrl_word import CtrlWord

pins = PinClient()
control = CtrlWord()

def setup():
    cpu.setup(pins, control)
