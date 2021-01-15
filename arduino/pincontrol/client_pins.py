#!/usr/bin/python3

import sys, cmd, serial

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

    def do_ctrl_off(self, arg):
        self.pins.off()

    def do_bus_set(self, arg):
        self.pins.bus_set(arg)

    def do_bus_get(self, arg):
        chr = self.pins.bus_get()
        print (chr)

    def do_bus_free(self, arg):
        self.pins.bus_free()

    def do_flags_get(self, arg):
        print (self.pins.flags_get())

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

    def do_add_sample(self, arg):
        self.pins.ctrl_off()
        self.pins.bus_set(24)
        self.pins.ctrl_clr(0)
        self.pins.ctrl_commit()
        self.pins.clock_pulse()
        self.pins.clock_inverted()
        self.pins.ctrl_set(0)
        self.pins.ctrl_clr(2)
        self.pins.ctrl_commit()
        self.pins.bus_set(18)
        self.pins.clock_pulse()
        self.pins.clock_inverted()
        self.pins.bus_free()
        self.pins.ctrl_set(2)
        self.pins.ctrl_clr(3)
        self.pins.ctrl_commit()
        print(self.pins.bus_get())
        self.pins.ctrl_set(3)
        self.pins.ctrl_commit()

if __name__ == "__main__":
    TesterClient().cmdloop()
