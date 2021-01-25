#!/usr/bin/python3

import sys, cmd, serial

from libpins import asm
from libpins.PinClient import PinClient
from libpins.cpu import CPU
from libpins.devices import Flags

from libpins.DeviceSetup import *
from libpins.ctrl_word import CtrlWord

control = CtrlWord()

ser = serial.Serial("/dev/ttyACM0", 9600, timeout=1)
pins = PinClient(ser)


class TesterClient(cmd.Cmd):

    def do_EOF(self, arg):
        ser.close()
        sys.exit(0)

    def do_identify(self, arg):
        'Identify device'
        chr = pins.identify()
        print (chr)

    def do_off(self, arg):
        control.reset()
        pins.off(control.default)
        print (bin(control.default))

    def do_load_mar(self, arg):
        Mar.load.enable()
        pins.bus_set(arg)
        pins.ctrl_commit(control.c_word)
        pins.clock_pulse()
        pins.clock_inverted()

        control.reset()
        pins.off(control.default)

    def do_write_ram(self, arg):
        Ram.write.enable()
        pins.bus_set(arg)
        pins.ctrl_commit(control.c_word)

        pins.clock_pulse()

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

    TesterClient().cmdloop()
