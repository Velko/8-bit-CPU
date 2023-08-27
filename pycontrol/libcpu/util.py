from abc import abstractmethod
from dataclasses import dataclass
from typing import TypeVar, Optional
from enum import Enum

class UninitializedError(Exception):
    pass

T = TypeVar('T')

def unwrap(val: Optional[T]) -> T:
    if val is None:
        raise UninitializedError
    return val

class ControlSignal:
    def __init__(self) -> None:
        self.name: Optional[str] = None

    @abstractmethod
    def apply_enable(self, c_word: int) -> int:
        pass

    def __repr__(self) -> str:
        if self.name is None:
            return super().__repr__()
        return f"{self.__class__.__name__}({self.name})"


@dataclass
class RunMessage:
    class Reason(Enum):
        OUT  = 0
        HALT = 1
        BRK  = 2

    reason: Reason
    payload: Optional[str]=None
