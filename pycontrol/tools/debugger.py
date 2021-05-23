#!/usr/bin/python3

import sys, cmd
import localpath

from libcpu.DeviceSetup import COutPort, LR, OutPort, PC, Clock, SP

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

        a_start = int(nums[0], 0)

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

class Debugger:
    def __init__(self) -> None:
        self.halted = False

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

        # fetch and execute an instruction
        outval = cpu_helper.backend.fetch_and_execute()

        # are we done?
        if Clock.halt.is_enabled():
            print ("# Halted", flush=True, file=sys.stderr)
            self.halted = True

        # catch output value
        if OutPort.load.is_enabled():
            print (outval, flush=True)
        if COutPort.load.is_enabled():
            print (chr(outval), end="", flush=True)

    def cont(self) -> None:

        if self.halted:
            print ("# Halted", flush=True, file=sys.stderr)

        while not self.halted:
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



debugger = Debugger()

if __name__ == "__main__":

    if len(sys.argv) > 1:
        debugger.upload(sys.argv[1])

    DebugCmd().cmdloop()