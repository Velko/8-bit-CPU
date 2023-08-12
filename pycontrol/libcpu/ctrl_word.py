#!/usr/bin/env python3

from typing import Iterable, Optional, Tuple, Any
from .discovery import all_pins
from .pin import PinBase
from .ctrl_base import CtrlBase
from .util import ControlSignal

class CtrlWord(CtrlBase):
    c_word: int

    def __init__(self, pins: Optional[Iterable[Tuple[str, PinBase]]]=None):

        if pins is None:
            self.c_word = DEFAULT_CW.c_word
        else:
            self.c_word = 0
            for _, pin in pins:
                pin.disable(self)

    def set(self, pin: int) -> None:
        self.c_word |= 1 << pin

    def clr(self, pin: int) -> None:
        self.c_word &= ~(1 << pin)

    def is_set(self, pin: int) -> bool:
        return (self.c_word & (1 << pin)) != 0

    def enable(self, pin: ControlSignal) -> None:
        pin.do_enable(self)

DEFAULT_CW = CtrlWord(all_pins())