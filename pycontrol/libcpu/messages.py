from dataclasses import dataclass

@dataclass
class OutMessage:
    target: int
    payload: str

@dataclass
class HaltMessage:
    ...

@dataclass
class BrkMessage:
    ...

RunMessage = OutMessage | HaltMessage | BrkMessage
