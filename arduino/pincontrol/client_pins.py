#!/usr/bin/python3

import sys, cmd, serial

from libpins.PinClient import PinClient
from libpins.cpu import CPU

ser = serial.Serial("/dev/ttyACM0", 9600, timeout=1)
ser = serial.Serial("/dev/ttyACM0", 9600, timeout=1)
pins = PinClient(ser)
cpu = CPU()
cpu.connect(pins)

class TesterClient(cmd.Cmd):

    def __init__(self):
        cmd.Cmd.__init__(self, stdout=self)

    def do_EOF(self, arg):
        ser.close()
        sys.exit(0)

    def do_identify(self, arg):
        'Identify device'
        chr = pins.identify()
        print (chr)

    def do_ctrl_off(self, arg):
        pins.off()

    def do_bus_set(self, arg):
        pins.bus_set(arg)

    def do_bus_get(self, arg):
        chr = pins.bus_get()
        print (chr)

    def do_bus_free(self, arg):
        pins.bus_free()

    def do_flags_get(self, arg):
        print (pins.flags_get())

    def do_ctrl_set(self, arg):
        pins.ctrl_set(int(arg))

    def do_ctrl_clr(self, arg):
        pins.ctrl_clr(int(arg))

    def do_ctrl_commit(self, arg):
        pins.ctrl_commit()

    def do_clock_pulse(self, arg):
        pins.clock_pulse()

    def do_clock_inverted(self, arg):
        pins.clock_inverted()

    def do_add_sample(self, arg):
        pins.off()
        pins.bus_set(24)
        pins.ctrl_clr(0)
        pins.ctrl_commit()
        pins.clock_pulse()
        pins.clock_inverted()
        pins.ctrl_set(0)
        pins.ctrl_clr(2)
        pins.ctrl_commit()
        pins.bus_set(18)
        pins.clock_pulse()
        pins.clock_inverted()
        pins.bus_free()
        pins.ctrl_set(2)
        pins.ctrl_clr(3)
        pins.ctrl_commit()
        print(pins.bus_get())
        pins.ctrl_set(3)
        pins.ctrl_commit()

if __name__ == "__main__":
    TesterClient().cmdloop()
