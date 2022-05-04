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
    def __init__(self) -> None:
        self.name: Optional[str] = None

    @abstractmethod
    def enable(self) -> None: pass

    def __repr__(self) -> str:
        if self.name is None:
            return super.__repr__(self)
        return self.name