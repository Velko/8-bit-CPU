#!/usr/bin/env python3

import localpath

from libcpu.discovery import simple_pins, mux_pins, all_muxes
from libcpu.pin import Pin, MuxPin
from typing import Sequence, Tuple

for name, pin in sorted(simple_pins(), key=lambda pin: pin[1].num):
    print ("{:2} {}".format(pin.num, name))

for name, mux in all_muxes():
    print (name, mux.pins)
    for name, mpin in sorted(mux_pins(mux), key=lambda pin: pin[1].num):
        print ("  ", mpin.num, name)