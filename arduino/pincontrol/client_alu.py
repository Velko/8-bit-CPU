#!/usr/bin/python3

import sys, cmd, serial

from libpins import PinClient, cpu

ser = serial.Serial("/dev/ttyACM0", 9600, timeout=1)

class TesterClient(cmd.Cmd):

    def __init__(self):
        cmd.Cmd.__init__(self, stdout=self)
        self.pins = PinClient.PinClient(ser)
        self.cpu = cpu.CPU(self.pins)

    def do_EOF(self, arg):
        ser.close()
        sys.exit(0)

    def do_identify(self, arg):
        'Identify device'
        chr = self.pins.identify()
        print (chr)

    def do_off(self, arg):
        self.pins.bus_free()
        self.pins.ctrl_off()

    def do_load_a(self, arg):
        self.cpu.op_ldi(self.cpu.reg_A, arg)

    def do_load_b(self, arg):
        self.cpu.op_ldi(self.cpu.reg_B, arg)

    def do_add_ab(self, arg):
        self.cpu.op_add(self.cpu.reg_A)

    def do_add_ba(self, arg):
        self.cpu.op_add(self.cpu.reg_B)

    def do_out_a(self, arg):
        val = self.cpu.op_out(self.cpu.reg_A)
        print(val)

    def do_out_b(self, arg):
        val = self.cpu.op_out(self.cpu.reg_B)
        print(val)


if __name__ == "__main__":
    TesterClient().cmdloop()
