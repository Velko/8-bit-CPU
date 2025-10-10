from abc import abstractmethod
from dataclasses import dataclass
from typing import TypeVar
from enum import Enum

class UninitializedError(Exception):
    pass

T = TypeVar('T')

def unwrap(val: T | None) -> T:
    if val is None:
        raise UninitializedError
    return val

class ControlSignal:
    def __init__(self) -> None:
        self.name: str | None = None

    @abstractmethod
    def apply_enable(self, c_word: int) -> int:
        pass

    def __repr__(self) -> str:
        if self.name is None:
            return super().__repr__()
        return f"{self.__class__.__name__}({self.name})"

@dataclass
class OutMessage:
    target: int
    payload: str
    def formatted(self) -> str:
        if self.target == 0:
            return ansi_red(self.payload)
        return self.payload

@dataclass
class HaltMessage:
    ...

@dataclass
class BrkMessage:
    ...

RunMessage = OutMessage | HaltMessage | BrkMessage

def ansi_red(text: str) -> str:
    return f"\x1b[1;31m{text}\x1b[0m"