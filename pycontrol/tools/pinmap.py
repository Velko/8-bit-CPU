#!/usr/bin/env python3

from libcpu.discovery import simple_pins, mux_pins, all_muxes

pinmap: dict[int, str] = {}

for name, pin in simple_pins():
    pinmap[pin.num] = name

for name, mux in all_muxes():
    for i, mp in enumerate(mux.pins):
        pinmap[mp] = f"{name}.{i}"

# auto-adjust size of control word
largest = max(pinmap.keys())
totalpins = (largest + 8) & ~7

for p in range(totalpins):
    if p != 0 and (p & 7) == 0:
        print ("-----------------------------")

    if p in pinmap:
        print (f"{p:2} {pinmap[p]}")
    else:
        print (f"{p:2} -")

for name, mux in all_muxes():
    print (name, mux.pins)
    mpm: dict[int, str] = {}

    for mpname, mpin in mux_pins(mux):
        mpm[mpin.num] = mpname

    mpm[mux.default] = "(default)"

    capacity = 2**len(mux.pins)

    for p in range(capacity):
        if p != 0 and (p & 7) == 0:
            print ("   --------------------------")
        if p in mpm:
            print (f"  {p:2} {mpm[p]}")
        else:
            print (f"  {p:2} -")
