from typing import Optional, Sequence
from enum import Enum
from .ctrl_base import CtrlBase
from .util import ControlSignal
from abc import abstractmethod

class Level(Enum):
    LOW = 0
    HIGH = 1

def set_bit(c_word: int, pin: int) -> int:
    return c_word | (1 << pin)

def clr_bit(c_word: int, pin: int) -> int:
    return c_word & ~(1 << pin)

class PinBase(ControlSignal):
    def __init__(self) -> None:
        ControlSignal.__init__(self)

    @abstractmethod
    def apply_disable(self, c_word: int) -> int: pass

    @abstractmethod
    def check_enabled(self, control_word: CtrlBase) -> bool: pass


class Pin(PinBase):
    def __init__(self, num: int, level: Level) -> None:
        PinBase.__init__(self)
        self.num = num
        self.level = level

    def apply_enable(self, c_word: int) -> int:
        if self.level == Level.HIGH:
            return set_bit(c_word, self.num)
        else:
            return clr_bit(c_word, self.num)

    def apply_disable(self, c_word: int) -> int:
        if self.level == Level.HIGH:
            return clr_bit(c_word, self.num)
        else:
            return set_bit(c_word, self.num)

    def check_enabled(self, control_word: CtrlBase) -> bool:
        if self.level == Level.HIGH:
            return control_word.is_set(self.num)
        else:
            return not control_word.is_set(self.num)

class NullPin(PinBase):
    def __init__(self) -> None:
        PinBase.__init__(self)
        self._is_enabled = False

    def apply_enable(self, c_word: int) -> int:
        self._is_enabled = True
        return c_word

    def apply_disable(self, c_word: int) -> int:
        self._is_enabled = False
        return c_word

    def check_enabled(self, control_word: CtrlBase) -> bool:
        return self._is_enabled

class AliasedPin(PinBase):
    def __init__(self, target: PinBase) -> None:
        PinBase.__init__(self)
        self.target = target

    def apply_enable(self, c_word: int) -> int:
        return self.target.apply_enable(c_word)

    def apply_disable(self, c_word: int) -> int:
        return self.target.apply_disable(c_word)

    def check_enabled(self, control_word: CtrlBase) -> bool:
        return self.target.check_enabled(control_word)

class Mux:
    def __init__(self, name: str, pins: Sequence[int], default: int) -> None:
        self.name = name
        self.control_word: Optional[CtrlBase]  = None
        self.pins = pins
        self.default = default

    def apply_enable(self, c_word: int, num: int) -> int:
        for bit_idx, pin in enumerate(self.pins):
            if (num & (1 << bit_idx)) != 0:
                c_word = set_bit(c_word, pin)
            else:
                c_word = clr_bit(c_word, pin)

        return c_word

    def apply_disable(self, c_word: int, num: int) -> int:
        return self.apply_enable(c_word, self.default)

    def current(self, control_word: CtrlBase) -> int:
        result = 0
        for bit_idx, pin in enumerate(self.pins):
            if control_word.is_set(pin):
                result |= (1 << bit_idx)

        return result

class MuxPin(PinBase):
    def __init__(self, mux: Mux, num: int) -> None:
        PinBase.__init__(self)
        self.mux = mux
        self.num = num

    # There are some inefficiencies how MuxPin handles passing
    # the data back to Mux, but it does not matter much because
    # it occurs purely in Python
    # for example: Mux.connect() is called for by each MuxPin's
    # connect(), while calling it only once per Mux should be
    # enough. But it does not make any noticable impact on peformance
    def apply_enable(self, c_word: int) -> int:
        return self.mux.apply_enable(c_word, self.num)

    def apply_disable(self, c_word: int) -> int:
        return self.mux.apply_disable(c_word, self.num)

    def check_enabled(self, control_word: CtrlBase) -> bool:
        return self.mux.current(control_word) == self.num
