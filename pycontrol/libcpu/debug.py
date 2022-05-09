#!/usr/bin/python3

import sys
from typing import Dict, List, Mapping, Optional, Union
from enum import Enum

from .test_helpers import CPUHelper
from .DeviceSetup import COutPort, IR, LR, OutPort, PC, Clock, SP
from .pinclient import RunMessage
from .util import unwrap
from .opcodes import opcodes
from .cpu import A, B, C, D
from .cpu_exec import CPUBackendControl

class Breakpoint:
    def __init__(self, addr: int, orig_op: int):
        self.addr = addr
        self.orig_op = orig_op

class StopReason(Enum):
    DEBUG_BRK = 1
    CODE_BRK = 2
    STEP = 3
    HALT = 4

class Debugger:
    def __init__(self) -> None:
        self.cpu_helper = CPUHelper(CPUBackendControl())
        self.halted = False
        self.stopped = True

        self.breakpoints: Dict[int, Breakpoint] = {}

        self.current_break: Optional[Breakpoint] = None

        self.on_stop = self.stop_event
        self.on_output = self.output_event

    def disconnect(self) -> None:
        self.cpu_helper.backend.client.close()

    def read_ram(self, addr: int, size: int) -> bytes:
        data: List[int] = list()
        for i in range(size):
            data.append(self.cpu_helper.read_ram(addr + i))

        return bytes(data)


    def upload(self, file: str) -> None:

        with open(file, "rb") as f:
            binary = f.read()

        print ("# Uploading ", end="", flush=True, file=sys.stderr)

        for addr, byte in enumerate(binary):
            self.cpu_helper.write_ram(addr, byte)

            print (".", end="", flush=True, file=sys.stderr)

        print (" OK", file=sys.stderr)

    def step(self) -> None:

        if self.halted:
            self.on_stop(StopReason.HALT, self.cpu_helper.read_reg16(PC))
            return

        if self.current_break is not None:
            # special case: active breakpoint
            _, outval = self.cpu_helper.backend.execute_opcode(self.current_break.orig_op)
            self.current_break = None
        else:
            # fetch and execute an instruction
            outval = self.cpu_helper.backend.fetch_and_execute()

        # are we done?
        if Clock.halt.is_enabled():
            self.halted = True
            self.stopped = True
            self.on_stop(StopReason.HALT, self.cpu_helper.read_reg16(PC))
            return

        # breakpoint?
        if Clock.brk.is_enabled():
            self.stopped = True
            tmp_break = self.break_hit()
            if tmp_break is not None:
                # when single-stepping, should ignore breakpoints and execute original
                # instruction immediately
                _, outval = self.cpu_helper.backend.execute_opcode(tmp_break.orig_op)
            else:
                # Must be BRK in code, execute NOP instead
                self.cpu_helper.backend.execute_mnemonic("nop")

        # catch output value
        if OutPort.load.is_enabled():
            self.on_output(f"{unwrap(outval)}\n")
        if COutPort.load.is_enabled():
            self.on_output(chr(unwrap(outval)))

        self.on_stop(StopReason.STEP, self.cpu_helper.read_reg16(PC))

    def cont(self) -> None:

        if self.halted:
            self.on_stop(StopReason.HALT, self.cpu_helper.read_reg16(PC))
            return

        self.stopped = False

        # if stopped on breakpoint, complete the instruction
        # before resuming hardware-side execution
        # flush flags cache, because hardware updated while we were not
        # observing
        if self.current_break is not None:
            self.cpu_helper.backend.flags_cache = None
            self.step()

        out = self.cpu_helper.backend.client.run_program();

        for msg in out:

            if msg.reason == RunMessage.Reason.HALT:
                self.halted = True
                self.stopped = True
                # report the addess of HLT, not one past
                self.on_stop(StopReason.HALT, self.cpu_helper.read_reg16(PC) - 1)
                break

            elif msg.reason == RunMessage.Reason.BRK:
                self.stopped = True
                self.current_break = self.break_hit()
                break

            elif msg.reason == RunMessage.Reason.OUT:
                self.on_output(unwrap(msg.payload))


    def reset(self) -> None:
        # Reset CPU
        self.cpu_helper.backend.client.reset()

        self.halted = False

    def run(self) -> None:

        self.reset()

        # Drumroll... now it should happen for real
        print ("# Running ...", flush=True, file=sys.stderr)
        self.cont()

    def set_breakpoint(self, addr: int) -> None:

        pmem = self.cpu_helper.read_ram(addr)

        bkp = Breakpoint(addr, pmem)

        self.breakpoints[addr] = bkp

        # replace it with brk()
        self.cpu_helper.write_ram(addr, opcodes["brk"].opcode)

    def clear_breakpoint(self, addr: int) -> None:

        if addr in self.breakpoints:
            self.cpu_helper.write_ram(addr, self.breakpoints[addr].orig_op)
            del self.breakpoints[addr]

    def break_hit(self) -> Optional[Breakpoint]:
        addr = self.cpu_helper.read_reg16(PC) - 1

        if addr in self.breakpoints:
            tmp_break = self.breakpoints[addr]
            self.cpu_helper.load_reg8(IR, tmp_break.orig_op)
            self.on_stop(StopReason.DEBUG_BRK, addr)
            return tmp_break
        else:
            self.on_stop(StopReason.CODE_BRK, addr)
            return None


    def stop_event(self, reason: StopReason, addr: int) -> None:
        if reason == StopReason.HALT:
            print ("# Halted", flush=True, file=sys.stderr)
        elif reason == StopReason.DEBUG_BRK:
            print (f"# Breakpoint @ {addr:04x}")
        elif reason == StopReason.CODE_BRK:
            print (f"# Hardcoded breakpoint @ {addr:04x}")

    def output_event(self, msg: str) -> None:
        print(msg, end="", flush=True)

    def get_registers(self) -> Mapping[str, Union[int, str]]:
        registers: Dict[str, Union[int, str]] = {
            "A": self.cpu_helper.read_reg8(A),
            "B": self.cpu_helper.read_reg8(B),
            "C": self.cpu_helper.read_reg8(C),
            "D": self.cpu_helper.read_reg8(D),
            "Flags": self.cpu_helper.get_flags_s(),
            "LR": self.cpu_helper.read_reg16(LR),
            "SP": self.cpu_helper.read_reg16(SP)
        }

        # if breakpoint just hit, PC is not accurate
        # show breakpoint address instead
        if self.current_break is not None:
            registers["PC"] = self.current_break.addr
        else:
            registers["PC"] = self.cpu_helper.read_reg16(PC)

        return registers

