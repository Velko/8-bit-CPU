#!/usr/bin/env python3

from libcpu.DeviceSetup import hardware as hw
from libcpu.ctrl_word import CtrlWord

if __name__ == "__main__":
    cw = CtrlWord()
    #cw.c_word = 0x17d558f9
    cw.c_word = 0x07ff58ff

    for name, pin in hw.all_pins():
        if cw.is_enabled(pin):
            print(pin)