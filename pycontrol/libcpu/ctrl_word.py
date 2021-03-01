#!/usr/bin/env python3

from typing import Iterator, Optional, Tuple
from .discovery import all_pins
from .pin import PinBase
from .ctrl_base import CtrlBase

class CtrlWord(CtrlBase):
    def __init__(self, pins: Optional[Iterator[Tuple[str, PinBase]]]=None):

        if pins is None:
            pins = all_pins()

        self.c_word = 0

        for name, pin in pins:
            pin.connect(self)
            pin.disable()

        self.default = self.c_word


    def set(self, pin: int) -> None:
        self.c_word |= 1 << pin

    def clr(self, pin: int) -> None:
        self.c_word &= ~(1 << pin)

    def reset(self) -> None:
        self.c_word = self.default

    def is_set(self, pin: int) -> bool:
        return (self.c_word & (1 << pin)) != 0
