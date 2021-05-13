#!/usr/bin/python3

from typing import List, Optional
from libcpu.util import unwrap

next_addr = 0

def org(address: int) -> None:
    global next_addr
    next_addr = address

def rewind(offset: int) -> None:
    global next_addr
    next_addr -= offset

def align(alignment: int) -> None:
    global next_addr

    mod = next_addr % alignment
    if mod != 0:
        next_addr += alignment - mod

class AddrBase:
    def a_bytes(self) -> List[int]: ...

    @staticmethod
    def make_bytes(addr: int) -> List[int]:
        return [(addr >> 8) & 0xFF, addr & 0xFF]

class Addr(AddrBase):
    def __init__(self, addr):
        self.addr = addr

    def a_bytes(self) -> List[int]:
        return AddrBase.make_bytes(self.addr)

class Bytes(AddrBase):
    def __init__(self, size: int) -> None:
        global next_addr

        self.start = next_addr
        self.size = size
        next_addr += size

    def a_bytes(self) -> List[int]:
        return AddrBase.make_bytes(self.start)


class Byte(Bytes):
    def __init__(self) -> None:
        Bytes.__init__(self, 1)

class Label(AddrBase):
    def __init__(self) -> None:
        self.addr: Optional[int] = None

    def here(self) -> None:
        self.addr = next_addr

    def a_bytes(self) -> List[int]:
        return AddrBase.make_bytes(unwrap(self.addr))

class String(Bytes):
    def __init__(self, text: str) -> None:
        self.data = text.encode("ascii") + b'\0'
        Bytes.__init__(self, len(self.data))
