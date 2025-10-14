#!/usr/bin/env python3

from collections.abc import Iterable
from typing import Self
from .pin import ControlSignal, Pin
from .util import UninitializedError

default_cw: int | None = None

class CtrlWord:
    def __init__(self, pins: Iterable[tuple[str, Pin]] | None = None):
        self.c_word = 0
        if pins is None:
            if default_cw is not None:
                self.c_word = default_cw
            else:
                raise UninitializedError("No default control word set, and no pins provided")
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

    def set_default(self) -> None:
        global default_cw
        default_cw = self.c_word

