from typing import Optional, Sequence
from enum import Enum
from .ctrl_base import CtrlBase
from .util import UninitializedError, ControlSignal
from abc import abstractmethod

class Level(Enum):
    LOW = 0
    HIGH = 1

class PinBase(ControlSignal):
    @abstractmethod
    def connect(self, control_word: CtrlBase) -> None: pass

    @abstractmethod
    def disable(self) -> None: pass

    @abstractmethod
    def is_enabled(self) -> bool: pass


class Pin(PinBase):
    def __init__(self, num: int, level: Level):
        self.control_word: Optional[CtrlBase] = None
        self.num = num
        self.level = level

    def connect(self, control_word: CtrlBase) -> None:
        self.control_word = control_word

    def enable(self) -> None:
        if self.control_word is None:
            raise UninitializedError

        if self.level == Level.HIGH:
            self.control_word.set(self.num)
        else:
            self.control_word.clr(self.num)

    def disable(self) -> None:
        if self.control_word is None:
            raise UninitializedError

        if self.level == Level.HIGH:
            self.control_word.clr(self.num)
        else:
            self.control_word.set(self.num)

    def is_enabled(self) -> bool:
        if self.control_word is None:
            raise UninitializedError

        if self.level == Level.HIGH:
            return self.control_word.is_set(self.num)
        else:
            return not self.control_word.is_set(self.num)

class NullPin(PinBase):
    def __init__(self, num: int, level: Level):
        self.num = None

    def connect(self, control_word: CtrlBase) -> None:
        pass

    def enable(self) -> None:
        pass

    def disable(self) -> None:
        pass

    def is_enabled(self) -> bool:
        return False


class Mux:
    def __init__(self, pins: Sequence[int], default: int):
        self.control_word: Optional[CtrlBase]  = None
        self.pins = pins
        self.default = default

    def connect(self, control_word: CtrlBase) -> None:
        self.control_word = control_word

    def enable(self, num: int) -> None:
        if self.control_word is None:
            raise UninitializedError

        for bit_idx, pin in enumerate(self.pins):
            if (num & (1 << bit_idx)) != 0:
                self.control_word.set(pin)
            else:
                self.control_word.clr(pin)

    def disable(self) -> None:
        self.enable(self.default)

    def current(self) -> int:
        if self.control_word is None:
            raise UninitializedError

        result = 0
        for bit_idx, pin in enumerate(self.pins):
            if self.control_word.is_set(pin):
                result |= (1 << bit_idx)

        return result

class MuxPin(PinBase):
    def __init__(self, mux: Mux, num: int):
        self.mux = mux
        self.num = num

    # There are some inefficiencies how MuxPin handles passing
    # the data back to Mux, but it does not matter much because
    # it occurs purely in Python
    # for example: Mux.connect() is called for by each MuxPin's
    # connect(), while calling it only once per Mux should be
    # enough. But it does not make any noticable impact on peformance
    def connect(self, control_word: CtrlBase) -> None:
        self.mux.connect(control_word)

    def enable(self) -> None:
        self.mux.enable(self.num)

    def disable(self) -> None:
        self.mux.disable()

    def is_enabled(self) -> bool:
        return self.mux.current() == self.num
