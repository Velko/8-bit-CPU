#!/usr/bin/python3

import sys, cmd

from libcpu.cpu import *
from libcpu.devices import Flags
from libcpu.PyAsmExec import pins, control

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

    def do_load_mar(self, arg):
        Mar.load.enable()
        pins.bus_set(arg)
        pins.ctrl_commit(control.c_word)
        pins.clock_tick()

        control.reset()
        pins.off(control.default)

    def do_write_ram(self, arg):
        Ram.write.enable()
        pins.bus_set(arg)
        pins.ctrl_commit(control.c_word)

        pins.clock_tick()

        control.reset()
        pins.off(control.default)

    def do_read_ram(self, arg):
        Ram.out.enable()

        pins.ctrl_commit(control.c_word)
        val = pins.bus_get()

        control.reset()
        pins.off(control.default)

        print (hex(val))


if __name__ == "__main__":

    from libcpu import PyAsmExec

    PyAsmExec.setup()

    TesterClient().cmdloop()
