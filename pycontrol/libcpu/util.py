class UninitializedError(Exception):
    pass

def to_i8(b: int) -> int:
    if b > 127:
        return b - 256
    return b

def to_u8(b: int) -> int:
    return b & 0xFF
