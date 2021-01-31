#!/usr/bin/python3

import sys, cmd

from libpins.cpu import *
from libpins.devices import Flags
from libpins.PyAsmExec import pins

class TesterClient(cmd.Cmd):

    def do_EOF(self, arg):
        ser.close()
        sys.exit(0)

    def do_identify(self, arg):
        'Identify device'
        chr = pins.identify()
        print (chr)

    def do_off(self, arg):
        pins.off()
        print (bin(pins.defaults))

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


if __name__ == "__main__":

    from libpins import PyAsmExec

    PyAsmExec.setup()

    TesterClient().cmdloop()
