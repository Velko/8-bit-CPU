#!/usr/bin/env python3

from abc import abstractmethod

class CtrlBase:
    @abstractmethod
    def set(self, pin: int) -> None: pass

    @abstractmethod
    def clr(self, pin: int) -> None: pass

    @abstractmethod
    def is_set(self, pin: int) -> bool: pass
