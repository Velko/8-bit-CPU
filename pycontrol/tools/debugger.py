#!/usr/bin/python3

import sys
import cmd

from libcpu.debug import Debugger

class DebugCmd(cmd.Cmd):
    prompt="(dbg) "
    def do_EOF(self, _arg: str) -> None:
        debugger.disconnect()
        sys.exit(0)

    def do_upload(self, arg: str) -> None:
        debugger.upload(arg)

    def do_run(self, _arg: str) -> None:
        debugger.run()

    def do_step(self, _arg: str) -> None:
        debugger.step()

    def do_continue(self, _arg: str) -> None:
        debugger.cont()

    def do_steprun(self, _arg: str) -> None:
        debugger.steprun()

    def do_reset(self, _arg: str) -> None:
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

        mem = debugger.read_ram(a_start, a_len)

        for d in mem:
            print (f"{d:02x} ", end="")
        print()

    def do_regs(self, _arg: str) -> None:
        regs = debugger.get_registers()

        print (f"A = {regs['A']:02x}")
        print (f"B = {regs['B']:02x}")
        print (f"C = {regs['C']:02x}")
        print (f"D = {regs['D']:02x}")
        print (f"Flags = {regs['Flags']}")
        print (f"PC = {regs['PC']:04x}")
        print (f"LR = {regs['LR']:04x}")
        print (f"SP = {regs['SP']:04x}")

    def do_break(self, arg: str) -> None:
        if not arg:
            print ("Usage:\nbreak <addr>")
            return

        b_addr = int(arg, 16)

        debugger.set_breakpoint(b_addr)



debugger = Debugger()

if __name__ == "__main__":

    if len(sys.argv) > 1:
        debugger.upload(sys.argv[1])

    DebugCmd().cmdloop()
