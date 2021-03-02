from abc import abstractmethod
from typing import TypeVar, Optional

class UninitializedError(Exception):
    pass

T = TypeVar('T')

def unwrap(val: Optional[T]) -> T:
    if val is None:
        raise UninitializedError
    return val

class ControlSignal:
    @abstractmethod
    def enable(self) -> None: pass

