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