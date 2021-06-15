#!/usr/bin/env python3

import localpath

from libcpu.discovery import simple_pins, mux_pins, all_muxes
from libcpu.pin import Pin, MuxPin
from typing import Dict, Sequence, Tuple

pinmap: Dict[int, str] = {}

for name, pin in simple_pins():
    pinmap[pin.num] = name

for name, mux in all_muxes():
    for i, mp in enumerate(mux.pins):
        pinmap[mp] = f"{name}.{i}"

for p in range(32):
    if p in pinmap:
        print (f"{p:2} {pinmap[p]}")
    else:
        print (f"{p:2} -")

for name, mux in all_muxes():
    print (name, mux.pins)
    mpm: Dict[int, str] = {}

    for mpname, mpin in mux_pins(mux):
        mpm[mpin.num] = mpname

    mpm[mux.default] = "(default)"

    capacity = 2**len(mux.pins)

    for p in range(capacity):
        if p in mpm:
            print (f"  {p:2} {mpm[p]}")
        else:
            print (f"  {p:2} -")
