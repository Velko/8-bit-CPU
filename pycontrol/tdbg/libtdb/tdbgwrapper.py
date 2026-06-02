
from collections.abc import Mapping

from libcpu.debug import Debugger, StopReason
from textual.dom import DOMNode
from textual.message import Message

class RegistersMessage(Message):
    def __init__(self, registers: Mapping[str, str]) -> None:
        self.registers = registers
        super().__init__()

class StopMessage(Message):
    def __init__(self, reason: StopReason, addr: int) -> None:
        self.reason = reason
        self.addr = addr
        super().__init__()

class OutputMessage(Message):
    def __init__(self, target: int, data: str) -> None:
        self.target = target
        self.data = data
        super().__init__()

class TDBGWrapper:
    def __init__(self, owner: DOMNode) -> None:
        self.owner = owner
        self.debugger = Debugger()
        self.debugger.on_stop = self.on_stop
        self.debugger.on_output = self.on_output

    def on_stop(self, reason: StopReason, addr: int) -> None:
        self.owner.post_message(StopMessage(reason, addr))

    def on_output(self, target: int, msg: str) -> None:
        self.owner.post_message(OutputMessage(target, msg))

    def get_registers(self) -> Mapping[str, str]:
        return self.owner.run_worker(self._get_registers)

    async def _get_registers(self) -> None:
        regs = self.debugger.get_registers()
        self.owner.post_message(RegistersMessage(regs))

    def step(self) -> None:
        self.owner.run_worker(self._step)

    async def _step(self) -> None:
        self.debugger.step()
