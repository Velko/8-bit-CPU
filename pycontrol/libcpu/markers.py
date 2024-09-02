#!/usr/bin/python3

from abc import abstractmethod

class AddrBase:
    @abstractmethod
    def a_bytes(self) -> list[int]: ...

    @staticmethod
    def make_bytes(addr: int) -> list[int]:
        return [addr & 0xFF, (addr >> 8) & 0xFF]

class Addr(AddrBase):
    def __init__(self, addr: int) -> None:
        self.addr = addr

    def a_bytes(self) -> list[int]:
        return AddrBase.make_bytes(self.addr)
