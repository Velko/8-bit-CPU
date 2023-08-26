#!/usr/bin/env python3

from libcpu.util import unwrap, RunMessage
from libcpu.devices import Register, WORegister
from libcpu.opcodes import InvalidOpcodeException, opcode_of
from libcpu.pinclient import PinClient
from libcpu.DeviceSetup import Flags, PC, Ram
from libcpu.ctrl_word import CtrlWord, DEFAULT_CW
from io import StringIO

class CPUHelper:
    def __init__(self, client: PinClient) -> None:
        self.client = client

    def load_reg16(self, reg: Register, value: int) -> None:
        control = CtrlWord()\
            .enable(reg.load)
        self.client.addr_set(value)
        self.client.ctrl_commit(control.c_word)
        self.client.clock_tick()

        self.client.off(DEFAULT_CW.c_word)


    def read_reg16(self, reg: Register) -> int:
        control = CtrlWord()\
            .enable(reg.out)
        self.client.ctrl_commit(control.c_word)
        value = self.client.addr_get()

        self.client.off(DEFAULT_CW.c_word)

        return value


    def read_ram(self, addr: int) -> int:
        self.client.addr_set(addr)
        control = CtrlWord()\
            .enable(Ram.out)
        self.client.ctrl_commit(control.c_word)

        value = self.client.bus_get()

        self.client.off(DEFAULT_CW.c_word)

        return value

    def write_ram(self, addr: int, value: int) -> None:
        control = CtrlWord()\
            .enable(Ram.write)
        self.client.ctrl_commit(control.c_word)

        self.client.addr_set(addr)
        self.client.bus_set(value)

        self.client.clock_tick()

        self.client.off(DEFAULT_CW.c_word)

    def write_bytes(self, addr: int, data: bytes) -> None:
        for i, b in enumerate(data):
            self.write_ram(addr + i, b)

    def get_flags(self) -> int:
        return self.client.flags_get()

    def get_flags_s(self) -> str:
        return Flags.decode(self.get_flags())

    def read_reg8(self, reg: Register) -> int:
        control = CtrlWord()\
            .enable(reg.out)
        self.client.ctrl_commit(control.c_word)
        value = self.client.bus_get()

        self.client.off(DEFAULT_CW.c_word)

        return value

    def load_reg8(self, reg: Register | WORegister , value: int) -> None:
        control = CtrlWord()\
            .enable(reg.load)
        self.client.bus_set(value)
        self.client.ctrl_commit(control.c_word)
        self.client.clock_tick()
        self.client.off(DEFAULT_CW.c_word)

    def load_snippet(self, addr: int, code: bytes) -> None:
        self.write_bytes(addr, code)
        self.load_reg16(PC, addr)

    def run_snippet(self, addr: int, code: bytes) -> str:
        """Run pre-compiled binary snippet. BRK instruction is appended automatically
           and execution terminates when it is reached.

           Args:
                addr: where code is loaded and PC is pointed to.
                code: byte array of binary code to execute.

           Returns:
                if there was port output from the program, it is returned as string

           Raises:
                InvalidOpcodeException: If code execution encounters HLT instruction.
        """

        # append 'brk'
        code_terminated = bytearray(code)
        code_terminated.append(opcode_of('brk'))

        self.load_snippet(addr, bytes(code_terminated))

        captured_output = StringIO()

        for msg in self.client.run_program():
            if msg.reason == RunMessage.Reason.BRK: break
            if msg.reason == RunMessage.Reason.HALT: raise InvalidOpcodeException("Unexpected exit")
            if msg.reason == RunMessage.Reason.OUT:
                captured_output.write(unwrap(msg.payload))

        return captured_output.getvalue()