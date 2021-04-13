#!/usr/bin/python3

from typing import Optional

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

class Bytes:
    def __init__(self, size: int) -> None:
        global next_addr

        self.start = next_addr
        self.size = size
        next_addr += size

class Byte(Bytes):
    def __init__(self) -> None:
        Bytes.__init__(self, 1)

class Label:
    def __init__(self) -> None:
        self.addr: Optional[int] = None

    def here(self) -> None:
        self.addr = next_addr
