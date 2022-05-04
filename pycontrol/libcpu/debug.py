#!/usr/bin/python3

import sys
from typing import Dict, List, Mapping, Optional, Union

from .test_helpers import CPUHelper
from .cpu import ret, setup_live
from .DeviceSetup import IOCtl, IR, LR, PC, Clock, SP
from .pinclient import RunMessage
from .util import unwrap
from .opcodes import opcodes
from .cpu import A, B, C, D

cpu_helper: CPUHelper = CPUHelper(setup_live())

class Breakpoint:
    def __init__(self, addr: int, orig_op: int):
        self.addr = addr
        self.orig_op = orig_op


class Debugger:
    def __init__(self) -> None:
        self.halted = False
        self.stopped = True

        self.breakpoints: Dict[int, Breakpoint] = {}

        self.current_break: Optional[Breakpoint] = None

    def disconnect(self) -> None:
        cpu_helper.backend.client.close()

    def read_ram(self, addr: int, size: int) -> bytes:
        data: List[int] = list()
        for i in range(size):
            data.append(cpu_helper.read_ram(addr + i))

        return bytes(data)


    def upload(self, file: str) -> None:

        with open(file, "rb") as f:
            binary = f.read()

        print ("# Uploading ", end="", flush=True, file=sys.stderr)

        for addr, byte in enumerate(binary):
            cpu_helper.write_ram(addr, byte)

            print (".", end="", flush=True, file=sys.stderr)

        print (" OK", file=sys.stderr)

    def step(self) -> None:

        if self.halted:
            print ("# Halted", flush=True, file=sys.stderr)
            return

        if self.current_break is not None:
            # special case: active breakpoint
            _ = cpu_helper.backend.execute_opcode(self.current_break.orig_op)
            self.current_break = None
        else:
            # fetch and execute an instruction
            cpu_helper.backend.fetch_and_execute()

        # are we done?
        if Clock.halt.is_enabled():
            print ("# Halted", flush=True, file=sys.stderr)
            self.halted = True
            self.stopped = True

        # breakpoint?
        if Clock.brk.is_enabled():
            self.stopped = True
            self.break_hit()

        # port output
        if IOCtl.to_dev.is_enabled():
            if IOCtl.selected_port == 0:
                print (unwrap(IOCtl.saved_value), flush=True)
            elif IOCtl.selected_port == 4:
                print (chr(unwrap(IOCtl.saved_value)), end="", flush=True)

            IOCtl.reset_port()

    def cont(self) -> None:

        if self.halted:
            print ("# Halted", flush=True, file=sys.stderr)
            return

        self.stopped = False

        # if stopped on breakpoint, complete the instruction
        # before resuming hardware-side execution
        if self.current_break is not None:
            self.step()

        out = cpu_helper.backend.client.run_program();

        for msg in out:

            if msg.reason == RunMessage.Reason.HALT:
                print ("# Halted", flush=True, file=sys.stderr)
                self.halted = True
                self.stopped = True
                break

            elif msg.reason == RunMessage.Reason.BRK:
                self.stopped = True
                self.break_hit()
                break

            elif msg.reason == RunMessage.Reason.OUT:
                print(msg.payload, end="", flush=True)


    def reset(self) -> None:
        # Reset CPU
        cpu_helper.backend.client.reset()

        self.halted = False

    def run(self) -> None:

        self.reset()

        # Drumroll... now it should happen for real
        print ("# Running ...", flush=True, file=sys.stderr)
        self.cont()

    def set_breakpoint(self, addr: int) -> None:

        pmem = cpu_helper.read_ram(addr)

        bkp = Breakpoint(addr, pmem)

        self.breakpoints[addr] = bkp

        # replace it with brk()
        cpu_helper.write_ram(addr, opcodes["brk"].opcode)

    def break_hit(self) -> None:
        addr = cpu_helper.read_reg16(PC) - 1

        if addr in self.breakpoints:
            self.current_break = self.breakpoints[addr]
            cpu_helper.load_reg8(IR, self.current_break.orig_op)
            print (f"# Breakpoint @ {addr:04x}")
        else:
            print (f"# Hardcoded breakpoint @ {addr:04x}")

    def get_registers(self) -> Mapping[str, Union[int, str]]:
        registers: Dict[str, Union[int, str]] = {
            "A": cpu_helper.read_reg8(A),
            "B": cpu_helper.read_reg8(B),
            "C": cpu_helper.read_reg8(C),
            "D": cpu_helper.read_reg8(D),
            "Flags": cpu_helper.get_flags_s(),
            "LR": cpu_helper.read_reg16(LR),
            "SP": cpu_helper.read_reg16(SP)
        }

        # if breakpoint just hit, PC is not accurate
        # show breakpoint address instead
        if self.current_break is not None:
            registers["PC"] = self.current_break.addr
        else:
            registers["PC"] = cpu_helper.read_reg16(PC)

        return registers

