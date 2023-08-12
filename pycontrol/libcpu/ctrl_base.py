#!/usr/bin/env python3

from abc import abstractmethod
from .util import ControlSignal

class CtrlBase:
    @abstractmethod
    def is_set(self, pin: int) -> bool: pass

    @abstractmethod
    def enable(self, pin: ControlSignal) -> None: pass
