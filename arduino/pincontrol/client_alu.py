#!/usr/bin/python3

import sys, cmd, serial

from libpins import asm
from libpins.PinClient import PinClient
from libpins.cpu import CPU
from libpins.devices import Flags

ser = serial.Serial("/dev/ttyACM0", 9600, timeout=1)
pins = PinClient(ser)
cpu = CPU()
cpu.connect(pins)


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
        ldi(A, arg)

    def do_load_b(self, arg):
        ldi(B, arg)

    def do_load_f(self, arg):
        ldi(F, arg)

    def do_add_ab(self, arg):
        add(A, B)

    def do_add_ba(self, arg):
        add(B, A)

    def do_sub_ab(self, arg):
        sub(A, B)

    def do_out_a(self, arg):
        val = out(A)
        print(val)

    def do_out_b(self, arg):
        val = out(B)
        print(val)

    def do_flags_get(self, arg):
        val = pins.flags_get()
        print (Flags.decode(val))

    def do_fibo(self, arg):

        ldi(A, 0)
        ldi(B, 1)

        print(out(A))
        print(out(B))

        for _ in range(6):
            add(A, B)
            print(out(A))

            add(B, A)
            print(out(B))


if __name__ == "__main__":

    asm.export_isa(cpu, globals())
    TesterClient().cmdloop()
