#!/usr/bin/python3

import sys, cmd
from typing import Dict, Optional
import localpath

from libcpu.DeviceSetup import COutPort, IR, LR, OutPort, PC, Clock, SP
from libcpu.opcodes import opcodes
from libcpu.PyAsmExec import setup_live
setup_live(False)
from libcpu.cpu import A, B, C, D, backend

from libcpu.test_helpers import CPUHelper
cpu_helper = CPUHelper(backend)


class DebugCmd(cmd.Cmd):
    prompt="(dbg) "
    def do_EOF(self, arg: str) -> None:
        cpu_helper.backend.client.close()
        sys.exit(0)

    def do_upload(self, arg: str) -> None:
        debugger.upload(arg)

    def do_run(self, arg: str) -> None:
        debugger.run()

    def do_step(self, arg: str) -> None:
        debugger.step()

    def do_continue(self, arg: str) -> None:
        debugger.cont()

    def do_reset(self, arg: str) -> None:
        debugger.reset()

    def do_mem(self, arg: str) -> None:
        nums = arg.split(" ")

        if len(nums) < 1 or not arg:
            print ("Usage:\nmem <start> [len]")
            return

        a_start = int(nums[0], 16)

        a_len = 1
        if len(nums) > 1:
            a_len = int(nums[1], 0)

        for i in range(a_len):
            d = cpu_helper.read_ram(a_start + i)
            print (f"{d:02x} ", end="")
        print()

    def do_regs(self, arg: str) -> None:
        print (f"A = {cpu_helper.read_reg8(A):02x}")
        print (f"B = {cpu_helper.read_reg8(B):02x}")
        print (f"C = {cpu_helper.read_reg8(C):02x}")
        print (f"D = {cpu_helper.read_reg8(D):02x}")
        print (f"Flags = {cpu_helper.get_flags_s()}")
        print (f"PC = {cpu_helper.read_reg16(PC):04x}")
        print (f"LR = {cpu_helper.read_reg16(LR):04x}")
        print (f"SP = {cpu_helper.read_reg16(SP):04x}")

    def do_break(self, arg: str) -> None:
        if not arg:
            print ("Usage:\nbreak <addr>")
            return

        b_addr = int(arg, 16)

        debugger.set_breakpoint(b_addr)


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
            _, outval = cpu_helper.backend.execute_opcode(self.current_break.orig_op)
            self.current_break = None
        else:
            # fetch and execute an instruction
            outval = cpu_helper.backend.fetch_and_execute()

        # are we done?
        if Clock.halt.is_enabled():
            print ("# Halted", flush=True, file=sys.stderr)
            self.halted = True
            self.stopped = True

        # breakpoint?
        if Clock.brk.is_enabled():
            self.stopped = True
            self.break_hit()

        # catch output value
        if OutPort.load.is_enabled():
            print (outval, flush=True)
        if COutPort.load.is_enabled():
            print (chr(outval), end="", flush=True)

    def cont(self) -> None:

        if self.halted:
            print ("# Halted", flush=True, file=sys.stderr)
            return

        self.stopped = False

        while not self.stopped:
            self.step()

    def reset(self) -> None:
        # Reset PC
        cpu_helper.load_reg16(PC, 0)

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



debugger = Debugger()

if __name__ == "__main__":

    if len(sys.argv) > 1:
        debugger.upload(sys.argv[1])

    DebugCmd().cmdloop()