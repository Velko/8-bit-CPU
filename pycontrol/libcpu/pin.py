from typing import Optional, Sequence
from enum import Enum
from .ctrl_base import CtrlBase
from .util import UninitializedError, ControlSignal
from abc import abstractmethod

class Level(Enum):
    LOW = 0
    HIGH = 1

class PinBase(ControlSignal):
    def __init__(self) -> None:
        ControlSignal.__init__(self)

    @abstractmethod
    def do_disable(self, control_word: CtrlBase) -> None: pass

    @abstractmethod
    def is_enabled(self, control_word: CtrlBase) -> bool: pass


class Pin(PinBase):
    def __init__(self, num: int, level: Level) -> None:
        PinBase.__init__(self)
        self.num = num
        self.level = level

    def do_enable(self, control_word: CtrlBase) -> None:
        if self.level == Level.HIGH:
            control_word.set(self.num)
        else:
            control_word.clr(self.num)

    def do_disable(self, control_word: CtrlBase) -> None:
        if self.level == Level.HIGH:
            control_word.clr(self.num)
        else:
            control_word.set(self.num)

    def is_enabled(self, control_word: CtrlBase) -> bool:
        if self.level == Level.HIGH:
            return control_word.is_set(self.num)
        else:
            return not control_word.is_set(self.num)

class NullPin(PinBase):
    def __init__(self) -> None:
        PinBase.__init__(self)
        self._is_enabled = False

    def do_enable(self, control_word: CtrlBase) -> None:
        self._is_enabled = True

    def do_disable(self, control_word: CtrlBase) -> None:
        self._is_enabled = False

    def is_enabled(self, control_word: CtrlBase) -> bool:
        return self._is_enabled

class AliasedPin(PinBase):
    def __init__(self, target: PinBase) -> None:
        PinBase.__init__(self)
        self.target = target

    def do_enable(self, control_word: CtrlBase) -> None:
        self.target.do_enable(control_word)

    def do_disable(self, control_word: CtrlBase) -> None:
        self.target.do_disable(control_word)

    def is_enabled(self, control_word: CtrlBase) -> bool:
        return self.target.is_enabled(control_word)

class Mux:
    def __init__(self, name: str, pins: Sequence[int], default: int) -> None:
        self.name = name
        self.control_word: Optional[CtrlBase]  = None
        self.pins = pins
        self.default = default

    def enable(self, control_word: CtrlBase, num: int) -> None:
        for bit_idx, pin in enumerate(self.pins):
            if (num & (1 << bit_idx)) != 0:
                control_word.set(pin)
            else:
                control_word.clr(pin)

    def disable(self, control_word: CtrlBase) -> None:
        self.enable(control_word, self.default)

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
    def do_enable(self, control_word: CtrlBase) -> None:
        self.mux.enable(control_word, self.num)

    def do_disable(self, control_word: CtrlBase) -> None:
        self.mux.disable(control_word)

    def is_enabled(self, control_word: CtrlBase) -> bool:
        return self.mux.current(control_word) == self.num
