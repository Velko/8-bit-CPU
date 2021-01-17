#!/usr/bin/python3

import sys, cmd, serial

from libpins.PinClient import PinClient
from libpins.cpu import CPU
from libpins.ctrl_word import CtrlWord
from libpins import DeviceSetup, devices

control = CtrlWord()

ser = serial.Serial("/dev/ttyACM0", 9600, timeout=1)
ser = serial.Serial("/dev/ttyACM0", 9600, timeout=1)
pins = PinClient(ser)
cpu = CPU(pins, control)

pin_map = dict()

class TesterClient(cmd.Cmd):

    def __init__(self):
        cmd.Cmd.__init__(self, stdout=self)

    def complete_pin(self, text, line, begidx, endidx):
        return list(filter(lambda n: n.startswith(text), pin_map.keys()))


    def do_EOF(self, arg):
        ser.close()
        sys.exit(0)

    def do_identify(self, arg):
        'Identify device'
        chr = pins.identify()
        print (chr)

    def do_ctrl_off(self, arg):
        control.reset()
        pins.off(control.default)

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
        if arg in pin_map:
            control.ctrl_set(pin_map[arg].num)
        else:
            control.ctrl_set(int(arg))

    complete_ctrl_set = complete_pin

    def do_ctrl_clr(self, arg):
        if arg in pin_map:
            control.ctrl_clr(pin_map[arg].num)
        else:
            control.ctrl_clr(int(arg))

    complete_ctrl_clr = complete_pin

    def do_ctrl_enable(self, arg):
        pin_map[arg].enable()

    complete_ctrl_enable = complete_pin

    def do_ctrl_disable(self, arg):
        pin_map[arg].disable()

    complete_ctrl_disable = complete_pin

    def do_ctrl_commit(self, arg):
        pins.ctrl_commit(control.c_word)

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

def build_pinmap():

    for name, dev in vars(DeviceSetup).items():
        if dev.__class__.__module__ == 'libpins.devices':
            for a_name, attr in vars(dev).items():
                if a_name == "name": continue
                pin_name = "{}.{}".format(dev.name, a_name).lower()
                pin_map[pin_name] = attr

if __name__ == "__main__":
    build_pinmap()
    TesterClient().cmdloop()
