#!/usr/bin/python3

import sys, cmd
import localpath

from libcpu.util import unwrap
from libcpu.cpu import *
from libcpu.devices import Flags
from libcpu.DeviceSetup import Mar, Ram
from libcpu.PyAsmExec import setup_live, control
setup_live()
from libcpu.PyAsmExec import pins

class TesterClient(cmd.Cmd):

    def do_EOF(self, arg):
        pins.close()
        sys.exit(0)

    def do_identify(self, arg):
        'Identify device'
        chr = pins.identify()
        print (chr)

    def do_off(self, arg):
        control.reset()
        pins.off(control.default)
        print (bin(control.default))

    def do_load_a(self, arg):
        ldi(A, int(arg, 0))

    def do_load_b(self, arg):
        ldi(B, int(arg, 0))

    def do_load_f(self, arg):
        ldi(F, arg)

    def do_add_ab(self, arg):
        add(A, B)

    def do_add_ba(self, arg):
        add(B, A)

    def do_sub_ab(self, arg):
        sub(A, B)

    def do_out_a(self, arg):
        val = peek(A)
        print(val)

    def do_out_b(self, arg):
        val = peek(B)
        print(val)

    def do_flags_get(self, arg):
        val = pins.flags_get()
        print (Flags.decode(val))

    def do_load_mar(self, arg: str) -> None:
        control.reset()
        Mar.load.enable()
        p = unwrap(pins)
        p.bus_set(arg)
        p.ctrl_commit(control.c_word)
        p.clock_tick()

        control.reset()
        p.off(control.default)

    def do_write_ram(self, arg: str) -> None:
        Ram.write.enable()
        p = unwrap(pins)
        p.bus_set(arg)
        p.ctrl_commit(control.c_word)

        p.clock_tick()

        control.reset()
        p.off(control.default)

    def do_read_ram(self, arg):
        Ram.out.enable()

        pins.ctrl_commit(control.c_word)
        val = pins.bus_get()

        control.reset()
        pins.off(control.default)

        print (hex(val))

    def do_run(self, arg):
        try:
            for line in pins.run_program():
                print (line, end="", flush=True)
        except KeyboardInterrupt:
            pass

    def do_upload(self, arg):
        with open(arg, "rb") as f:
            for addr, data in enumerate(f.read()):
                control.reset()
                Mar.load.enable()
                pins.bus_set(addr)
                pins.ctrl_commit(control.c_word)
                pins.clock_tick()
                control.reset()

                Ram.write.enable()
                pins.bus_set(data)
                pins.ctrl_commit(control.c_word)
                pins.clock_tick()

                control.reset()
                pins.off(control.default)
                print (".", end="", flush=True)
        print ()


if __name__ == "__main__":

    TesterClient().cmdloop()
