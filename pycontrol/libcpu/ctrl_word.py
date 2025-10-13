#!/usr/bin/env python3

from collections.abc import Iterable
from typing import Self
from .DeviceSetup import hardware as hw
from .pin import Pin
from .util import ControlSignal

class CtrlWord:
    def __init__(self, pins: Iterable[tuple[str, Pin]] | None = None):
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


DEFAULT_CW = CtrlWord(hw.all_pins())
