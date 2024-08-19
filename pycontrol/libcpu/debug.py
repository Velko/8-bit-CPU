#!/usr/bin/python3

import sys
from typing import Dict, List, Mapping, Optional, Union
from enum import Enum
from dataclasses import dataclass

from .cpu_helper import CPUHelper
from .pinclient import PinClient
from .DeviceSetup import IR, LR, PC, SP, A, B, C, D
from .util import OutMessage, HaltMessage, BrkMessage
from .opcodes import opcodes
from .assisted_cpu import AssistedCPU

RAM_OFFSET = 0x0000

@dataclass
class Breakpoint:
    addr: int
    orig_op: int

class StopReason(Enum):
    DEBUG_BRK = 1
    CODE_BRK = 2
    STEP = 3
    HALT = 4

class Debugger:
    def __init__(self) -> None:
        self.client = PinClient()
        self.backend = AssistedCPU(self.client)
        self.cpu_helper = CPUHelper(self.client)
        self.halted = False
        self.stopped = True

        self.breakpoints: Dict[int, Breakpoint] = {}

        self.current_break: Optional[Breakpoint] = None

        self.on_stop = self.stop_event
        self.on_output = self.output_event

    def disconnect(self) -> None:
        self.client.close()

    def read_ram(self, addr: int, size: int) -> bytes:
        data: List[int] = []
        for i in range(size):
            data.append(self.cpu_helper.read_ram(addr + i))

        return bytes(data)


    def upload(self, file: str) -> None:

        with open(file, "rb") as f:
            binary = f.read()

        print (f"# Uploading {file} ", end="", flush=True, file=sys.stderr)

        for addr, byte in enumerate(binary):
            self.cpu_helper.write_ram(addr + RAM_OFFSET, byte)

            print (".", end="", flush=True, file=sys.stderr)

        print (" OK", file=sys.stderr)

    def step(self) -> None:

        if self.halted:
            self.on_stop(StopReason.HALT, self.cpu_helper.read_reg16(PC))
            return

        if self.current_break is not None:
            # special case: active breakpoint
            message = self.backend.execute_opcode(self.current_break.orig_op)
            self.current_break = None
        else:
            # fetch and execute an instruction
            message = self.backend.fetch_and_execute()

        # are we done?
        match message:
            case HaltMessage():
                self.halted = True
                self.stopped = True
                self.on_stop(StopReason.HALT, self.cpu_helper.read_reg16(PC))
                return

            # breakpoint?
            case BrkMessage():
                self.stopped = True
                tmp_break = self.break_hit()
                if tmp_break is not None:
                    # when single-stepping, should ignore breakpoints and execute original
                    # instruction immediately
                    _ = self.backend.execute_opcode(tmp_break.orig_op)
                else:
                    # Must be BRK in code, execute NOP instead
                    self.backend.execute_mnemonic("nop")

            # port output
            case OutMessage(payload):
                self.on_output(payload)

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
            self.backend.flags_cache = None
            self.step()

        self.client.run_program()
        out = self.client.receive_messages()

        for msg in out:
            match msg:
                case HaltMessage():
                    self.halted = True
                    self.stopped = True
                    # report the addess of HLT, not one past
                    self.on_stop(StopReason.HALT, self.cpu_helper.read_reg16(PC) - 1)
                    break

                case BrkMessage():
                    self.stopped = True
                    self.current_break = self.break_hit()
                    break

                case OutMessage(payload):
                    self.on_output(payload)


    def steprun(self) -> None:
        if self.halted:
            self.on_stop(StopReason.HALT, self.cpu_helper.read_reg16(PC))
            return

        self.stopped = False

        while not self.stopped:
            self.step()

    def reset(self) -> None:
        # Reset CPU
        self.client.reset()

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

        self.on_stop(StopReason.CODE_BRK, addr)
        return None


    def stop_event(self, reason: StopReason, addr: int) -> None:
        match reason:
            case StopReason.HALT:
                print ("# Halted", flush=True, file=sys.stderr)
            case StopReason.DEBUG_BRK:
                print (f"# Breakpoint @ {addr:04x}")
            case StopReason.CODE_BRK:
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
