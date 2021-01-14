#!/usr/bin/python3

import sys, cmd, serial, threading

from libpins import PinClient

ser = serial.Serial("/dev/ttyACM0", 9600, timeout=1)

class TesterClient(cmd.Cmd):

    def __init__(self):
        cmd.Cmd.__init__(self, stdout=self)
        self.pins = PinClient.PinClient(ser)

    def do_EOF(self, arg):
        ser.close()
        sys.exit(0)

    def do_identify(self, arg):
        'Identify device'
        chr = self.pins.identify()
        print (chr)

        self.pins.ctrl_off()

    def do_bus_set(self, arg):
        self.pins.bus_set(arg)

    def do_bus_get(self, arg):
        chr = self.pins.bus_get()
        print (chr)

    def do_bus_free(self, arg):
        self.pins.bus_free()

    def do_ctrl_set(self, arg):
        self.pins.ctrl_set(arg)

    def do_ctrl_clr(self, arg):
        self.pins.ctrl_clr(arg)

    def do_ctrl_commit(self, arg):
        self.pins.ctrl_commit()

    def do_clock_pulse(self, arg):
        self.pins.clock_pulse()

    def do_clock_inverted(self, arg):
        self.pins.clock_inverted()

if __name__ == "__main__":
    TesterClient().cmdloop()
