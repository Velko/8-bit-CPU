from typing import TypeVar

class UninitializedError(Exception):
    pass

T = TypeVar('T')

def unwrap(val: T | None) -> T:
    if val is None:
        raise UninitializedError
    return val

