from typing import Sequence
from enum import Enum
from abc import abstractmethod
from .util import ControlSignal

class Level(Enum):
    LOW = 0
    HIGH = 1

def set_bit(c_word: int, pin: int) -> int:
    return c_word | (1 << pin)

def clr_bit(c_word: int, pin: int) -> int:
    return c_word & ~(1 << pin)

def check_bit(c_word: int, pin: int) -> bool:
    return (c_word & (1 << pin)) != 0

class Pin(ControlSignal):
    def __init__(self) -> None:
        ControlSignal.__init__(self)

    @abstractmethod
    def apply_disable(self, c_word: int) -> int:
        pass

    @abstractmethod
    def check_enabled(self, c_word: int) -> bool:
        pass


class SimplePin(Pin):
    def __init__(self, num: int, level: Level) -> None:
        Pin.__init__(self)
        self.num = num
        self.level = level

    def apply_enable(self, c_word: int) -> int:
        if self.level == Level.HIGH:
            return set_bit(c_word, self.num)
        return clr_bit(c_word, self.num)

    def apply_disable(self, c_word: int) -> int:
        if self.level == Level.HIGH:
            return clr_bit(c_word, self.num)
        return set_bit(c_word, self.num)

    def check_enabled(self, c_word: int) -> bool:
        if self.level == Level.HIGH:
            return check_bit(c_word, self.num)
        return not check_bit(c_word, self.num)

class NullPin(Pin):
    def __init__(self) -> None:
        Pin.__init__(self)
        self._is_enabled = False

    def apply_enable(self, c_word: int) -> int:
        self._is_enabled = True
        return c_word

    def apply_disable(self, c_word: int) -> int:
        self._is_enabled = False
        return c_word

    def check_enabled(self, c_word: int) -> bool:
        return self._is_enabled

class AliasedPin(Pin):
    def __init__(self, target: Pin) -> None:
        Pin.__init__(self)
        self.target = target

    def apply_enable(self, c_word: int) -> int:
        return self.target.apply_enable(c_word)

    def apply_disable(self, c_word: int) -> int:
        return self.target.apply_disable(c_word)

    def check_enabled(self, c_word: int) -> bool:
        return self.target.check_enabled(c_word)

class Mux:
    def __init__(self, name: str, pins: Sequence[int], default: int) -> None:
        self.name = name
        self.pins = pins
        self.default = default

    def apply_enable(self, c_word: int, num: int) -> int:
        for bit_idx, pin in enumerate(self.pins):
            if (num & (1 << bit_idx)) != 0:
                c_word = set_bit(c_word, pin)
            else:
                c_word = clr_bit(c_word, pin)

        return c_word

    def apply_disable(self, c_word: int) -> int:
        return self.apply_enable(c_word, self.default)

    def current(self, c_word: int) -> int:
        result = 0
        for bit_idx, pin in enumerate(self.pins):
            if check_bit(c_word, pin):
                result |= (1 << bit_idx)

        return result

class MuxPin(Pin):
    def __init__(self, mux: Mux, num: int) -> None:
        Pin.__init__(self)
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
        return self.mux.apply_disable(c_word)

    def check_enabled(self, c_word: int) -> bool:
        return self.mux.current(c_word) == self.num
