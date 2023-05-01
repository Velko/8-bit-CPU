#!/usr/bin/python3

from typing import List
from abc import abstractmethod

class AddrBase:
    @abstractmethod
    def a_bytes(self) -> List[int]: ...

    @staticmethod
    def make_bytes(addr: int) -> List[int]:
        return [addr & 0xFF, (addr >> 8) & 0xFF]

class Addr(AddrBase):
    def __init__(self, addr: int) -> None:
        self.addr = addr

    def a_bytes(self) -> List[int]:
        return AddrBase.make_bytes(self.addr)
