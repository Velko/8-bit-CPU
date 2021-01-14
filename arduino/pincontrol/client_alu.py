#!/usr/bin/python3

import sys, cmd, serial

from libpins.PinClient import PinClient
from libpins.cpu import CPU
from libpins.devices import Flags

ser = serial.Serial("/dev/ttyACM0", 9600, timeout=1)
pins = PinClient(ser)
cpu = CPU(pins)


class TesterClient(cmd.Cmd):

    def do_EOF(self, arg):
        ser.close()
        sys.exit(0)

    def do_identify(self, arg):
        'Identify device'
        chr = pins.identify()
        print (chr)

    def do_off(self, arg):
        pins.bus_free()
        pins.ctrl_off()

    def do_load_a(self, arg):
        cpu.op_ldi(cpu.reg_A, arg)

    def do_load_b(self, arg):
        cpu.op_ldi(cpu.reg_B, arg)

    def do_add_ab(self, arg):
        cpu.op_add(cpu.reg_A)

    def do_add_ba(self, arg):
        cpu.op_add(cpu.reg_B)

    def do_out_a(self, arg):
        val = cpu.op_out(cpu.reg_A)
        print(val)

    def do_out_b(self, arg):
        val = cpu.op_out(cpu.reg_B)
        print(val)

    def do_flags_get(self, arg):
        val = pins.flags_get()
        print (Flags.decode(val))

    def do_fibo(self, arg):
        cpu.op_ldi(cpu.reg_A, 0)
        cpu.op_ldi(cpu.reg_B, 1)

        print(cpu.op_out(cpu.reg_A))
        print(cpu.op_out(cpu.reg_B))

        for _ in range(6):
            cpu.op_add(cpu.reg_A)
            print(cpu.op_out(cpu.reg_A))

            cpu.op_add(cpu.reg_B)
            print(cpu.op_out(cpu.reg_B))


if __name__ == "__main__":
    TesterClient().cmdloop()
