#!/usr/bin/env python3

from typing import Iterable, Optional, Tuple, Self
from .discovery import all_pins
from .pin import Pin
from .util import ControlSignal

class CtrlWord:
    def __init__(self, pins: Optional[Iterable[Tuple[str, Pin]]]=None):
        self.c_word = 0
        if pins is None:
            self.c_word = DEFAULT_CW.c_word
        else:
            for _, pin in pins:
                self.disable(pin)

    def enable(self, pin: ControlSignal) -> Self:
        self.c_word = pin.apply_enable(self.c_word)
        return self

    def disable(self, pin: Pin) -> Self:
        self.c_word = pin.apply_disable(self.c_word)
        return self

    def is_enabled(self, pin: Pin) -> bool:
        return pin.check_enabled(self.c_word)


DEFAULT_CW = CtrlWord(all_pins())
