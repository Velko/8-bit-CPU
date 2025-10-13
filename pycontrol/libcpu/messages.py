from abc import abstractmethod
from dataclasses import dataclass

from .util import ansi_red

@dataclass
class OutMessage:
    target: int
    payload: str
    def formatted(self) -> str:
        if self.target == 0:
            return ansi_red(self.payload)
        return self.payload

@dataclass
class HaltMessage:
    ...

@dataclass
class BrkMessage:
    ...

RunMessage = OutMessage | HaltMessage | BrkMessage
