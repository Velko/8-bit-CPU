#!/usr/bin/env python3

from libcpu.cpu import InvalidOpcodeException, opcode_of
from libcpu.devices import Register
from libcpu.cpu_exec import CPUBackendControl
from libcpu.DeviceSetup import Flags, PC, Ram
from libcpu.pinclient import RunMessage


class CPUHelper:
    def __init__(self, backend: CPUBackendControl) -> None:
        self.backend = backend

    def load_reg16(self, reg: Register, value: int) -> None:
        self.backend.control.reset()
        reg.load.enable()
        self.backend.client.addr_set(value)
        self.backend.client.ctrl_commit(self.backend.control.c_word)
        self.backend.client.clock_tick()

        self.backend.client.off(self.backend.control.default)


    def read_reg16(self, reg: Register) -> int:

        self.backend.control.reset()
        reg.out.enable()
        self.backend.client.ctrl_commit(self.backend.control.c_word)
        value = self.backend.client.addr_get()

        self.backend.client.off(self.backend.control.default)

        return value


    def read_ram(self, addr: int) -> int:
        self.backend.client.addr_set(addr)
        self.backend.control.reset()
        Ram.out.enable()
        self.backend.client.ctrl_commit(self.backend.control.c_word)

        value = self.backend.client.bus_get()

        self.backend.control.reset()
        self.backend.client.off(self.backend.control.default)

        return value

    def write_ram(self, addr: int, value: int) -> None:
        self.backend.control.reset()
        Ram.write.enable()
        self.backend.client.ctrl_commit(self.backend.control.c_word)

        self.backend.client.addr_set(addr)
        self.backend.client.bus_set(value)

        self.backend.client.clock_tick()

        self.backend.control.reset()
        self.backend.client.off(self.backend.control.default)

    def write_bytes(self, addr: int, data: bytes) -> None:
        for i, b in enumerate(data):
            self.write_ram(addr + i, data[i])

    def get_flags(self) -> int:
        return self.backend.client.flags_get()

    def get_flags_s(self) -> str:
        return Flags.decode(self.get_flags())

    def read_reg8(self, reg: Register) -> int:
        self.backend.control.reset()
        reg.out.enable()
        self.backend.client.ctrl_commit(self.backend.control.c_word)
        value = self.backend.client.bus_get()

        self.backend.client.off(self.backend.control.default)

        return value

    def load_reg8(self, reg: Register, value: int) -> None:
        self.backend.control.reset()
        reg.load.enable()
        self.backend.client.bus_set(value)
        self.backend.client.ctrl_commit(self.backend.control.c_word)
        self.backend.client.clock_tick()
        self.backend.control.reset()
        self.backend.client.off(self.backend.control.default)

    def load_snippet(self, addr: int, code: bytes) -> None:
        self.write_bytes(addr, code)
        self.load_reg16(PC, addr)

    def run_snippet(self, addr: int, code: bytes) -> None:
        """Run pre-compiled binary snippet. BRK instruction is appended automatically
           and execution terminates when it is reached.

           Args:
                addr: where code is loaded and PC is pointed to.
                code: byte array of binary code to execute.

           Raises:
                InvalidOpcodeException: If code execution encounters HLT instruction.
        """

        # append 'brk'
        code_terminated = bytearray(code)
        code_terminated.append(opcode_of('brk'))

        self.load_snippet(addr, bytes(code_terminated))

        for msg in self.backend.client.run_program():
            if msg.reason == RunMessage.Reason.BRK: break
            if msg.reason == RunMessage.Reason.HALT: raise InvalidOpcodeException("Unexpected exit")
