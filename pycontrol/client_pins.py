#!/usr/bin/python3

import sys, cmd
import localpath

from libpins.PinClient import PinClient
from libcpu.PyAsmExec import pins, control
from libcpu import DeviceSetup, devices

pin_map = dict()

class TesterClient(cmd.Cmd):

    def complete_pin(self, text, line, begidx, endidx):
        return list(filter(lambda n: n.startswith(text), pin_map.keys()))


    def do_EOF(self, arg):
        pins.close()
        sys.exit(0)

    def do_identify(self, arg):
        'Identify device'
        chr = pins.identify()
        print (chr)

    def do_off(self, arg):
        'Turn everything off, release Bus'
        control.reset()
        pins.off(control.default)
        print(bin(control.c_word))

    def do_send(self, arg):
        'Send value on to the Bus'
        pins.bus_set(arg)

    def do_bus(self, arg):
        'Read current value on the Bus'
        chr = pins.bus_get()
        print (chr)

    def do_release(self, arg):
        'Release bus'
        pins.bus_free()

    def do_flags(self, arg):
        'Read flags'
        print (pins.flags_get())

    def do_set(self, arg):
        'Set control pin ignoring active-high/low setting'
        if arg in pin_map:
            control.ctrl_set(pin_map[arg].num)
        else:
            control.ctrl_set(int(arg, 0))
        print(bin(control.c_word))

    complete_set = complete_pin

    def do_clr(self, arg):
        'Clear control pin ignoring active-high/low setting'
        if arg in pin_map:
            control.ctrl_clr(pin_map[arg].num)
        else:
            control.ctrl_clr(int(arg))
        print(bin(control.c_word))

    complete_clr = complete_pin

    def do_enable(self, arg):
        'Enable control pin according to active-high/low setting'
        pin_map[arg].enable()
        print(bin(control.c_word))

    complete_enable = complete_pin

    def do_disable(self, arg):
        'Disable control pin according to active-high/low setting'
        pin_map[arg].disable()
        print(bin(control.c_word))

    complete_disable = complete_pin

    def do_commit(self, arg):
        'Send the control word to Arduino'
        pins.ctrl_commit(control.c_word)

    def do_pulse(self, arg):
        'Pulse normal clock'
        pins.clock_pulse()

    def do_inverted(self, arg):
        'Pulse inverted clock'
        pins.clock_inverted()

    def do_tick(self, arg):
        'Pulse both clocks'
        pins.clock_tick()

    def do_add_sample(self, arg):
        pins.off()
        pins.bus_set(24)
        pins.ctrl_clr(0)
        pins.ctrl_commit()
        pins.clock_tick()
        pins.ctrl_set(0)
        pins.ctrl_clr(2)
        pins.ctrl_commit()
        pins.bus_set(18)
        pins.clock_tick()
        pins.bus_free()
        pins.ctrl_set(2)
        pins.ctrl_clr(3)
        pins.ctrl_commit()
        print(pins.bus_get())
        pins.ctrl_set(3)
        pins.ctrl_commit()

def build_pinmap():

    for name, dev in vars(DeviceSetup).items():
        if dev.__class__.__module__ == 'libcpu.devices':
            for a_name, attr in vars(dev).items():
                if a_name == "name": continue
                pin_name = "{}.{}".format(dev.name, a_name).lower()
                pin_map[pin_name] = attr

if __name__ == "__main__":

    from libcpu import PyAsmExec
    PyAsmExec.setup()

    build_pinmap()
    TesterClient().cmdloop()
