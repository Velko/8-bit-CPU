#!/usr/bin/python3

import sys
import cmd
import argparse

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

        for name, value in regs.items():
            print (f"{name} = {value}")


    def do_break(self, arg: str) -> None:
        if not arg:
            print ("Usage:\nbreak <addr>")
            return

        b_addr = int(arg, 16)

        debugger.set_breakpoint(b_addr)



debugger = Debugger()

if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        prog="debugger",
        description="Interactive debugger for the 8-bit CPU"
    )

    parser.add_argument("filename", nargs="?", help="binary file to upload")
    parser.add_argument("-s", "--steprun", action="store_true", help="execute the program in step-run mode (using assisted engine)")
    parser.add_argument("-r", "--run", action="store_true", help="execute the program in run mode (on hardware)")
    parser.add_argument("-i", "--interactive", action="store_true", help="keep interactive mode after program run completes")

    args = parser.parse_args()

    if args.filename:
        debugger.upload(args.filename)

    interactive = args.interactive

    if args.steprun:
        print ("# Step-running ...", flush=True, file=sys.stderr)
        debugger.reset()
        debugger.steprun()
    elif args.run:
        print ("# Running ...", flush=True, file=sys.stderr)
        debugger.reset()
        debugger.run()
    else:
        interactive = True

    if interactive:
        DebugCmd().cmdloop()
