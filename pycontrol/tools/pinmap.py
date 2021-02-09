#!/usr/bin/env python3

import localpath

from libcpu.discovery import all_pins, all_muxes
from libcpu.pin import Pin, MuxPin


simple_pins = sorted(filter(lambda pin: isinstance(pin[1], Pin), all_pins()), key=lambda pin: pin[1].num)

for name, pin in simple_pins:
        print ("{:2} {}".format(pin.num, name))

for name, mux in all_muxes():
    print (name, mux.pins)
    mux_pins = sorted(filter(lambda pin: isinstance(pin[1], MuxPin) and pin[1].mux == mux, all_pins()), key=lambda pin: pin[1].num)
    for name, pin in mux_pins:
        print ("  ", pin.num, name)