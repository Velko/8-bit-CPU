from typing import TypeVar
from enum import Enum

class UninitializedError(Exception):
    pass

T = TypeVar('T')

def unwrap(val: T | None) -> T:
    if val is None:
        raise UninitializedError
    return val

def ansi_red(text: str) -> str:
    return f"\x1b[1;31m{text}\x1b[0m"

def sign_extend(b: int) -> int:
    if b > 127:
        return b - 256
    return b