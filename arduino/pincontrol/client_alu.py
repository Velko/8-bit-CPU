#!/usr/bin/python3

import sys, cmd, serial

from libpins import PinClient, ALUSection

ser = serial.Serial("/dev/ttyACM0", 9600, timeout=1)

class TesterClient(cmd.Cmd):

    def __init__(self):
        cmd.Cmd.__init__(self, stdout=self)
        self.pins = PinClient.PinClient(ser)
        self.dev = ALUSection.ALUSection()
        self.dev.connect(self.pins)

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
        self.dev.RegA.load()
        self.pins.bus_set(arg)
        self.pins.ctrl_commit()
        self.pins.clock_pulse()
        self.pins.clock_inverted()
        self.pins.ctrl_off()
        self.pins.bus_free()

    def do_load_b(self, arg):
        self.dev.RegB.load()
        self.pins.bus_set(arg)
        self.pins.ctrl_commit()
        self.pins.clock_pulse()
        self.pins.clock_inverted()
        self.pins.ctrl_off()
        self.pins.bus_free()

    def do_add_ab(self, arg):
        self.dev.AddSub.out()
        self.dev.RegA.load()
        self.pins.ctrl_commit()
        self.pins.clock_pulse()
        self.pins.clock_inverted()
        self.pins.ctrl_off()

    def do_add_ba(self, arg):
        self.dev.AddSub.out()
        self.dev.RegB.load()
        self.pins.ctrl_commit()
        self.pins.clock_pulse()
        self.pins.clock_inverted()
        self.pins.ctrl_off()

    def do_out_a(self, arg):
        self.dev.RegA.out()
        self.pins.ctrl_commit()
        val = self.pins.bus_get()
        self.pins.ctrl_off()
        print(val)

    def do_out_b(self, arg):
        self.dev.RegB.out()
        self.pins.ctrl_commit()
        val = self.pins.bus_get()
        self.pins.ctrl_off()
        print(val)


if __name__ == "__main__":
    TesterClient().cmdloop()
