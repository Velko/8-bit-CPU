#!/usr/bin/env python3

from libcpu.DeviceSetup import hardware as hw

pinmap: dict[int, str] = {}

for name, pin in hw.simple_pins():
    pinmap[pin.num] = name

for name, mux in hw.all_muxes():
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

for name, mux in hw.all_muxes():
    print (name, mux.pins)
    mpm: dict[int, str] = {}

    mpm[mux.default] = "(default)"

    for mpname, mpin in hw.mux_pins(mux):
        if mpin.num == mux.default:
            mpm[mux.default] = f"{mpname} (default)"
        else:
            mpm[mpin.num] = mpname


    capacity = 2**len(mux.pins)

    for p in range(capacity):
        if p != 0 and (p & 7) == 0:
            print ("   --------------------------")
        if p in mpm:
            print (f"  {p:2} {mpm[p]}")
        else:
            print (f"  {p:2} -")
