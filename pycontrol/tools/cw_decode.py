#!/usr/bin/env python3

import localpath
localpath.install()

from libcpu.discovery import all_pins
from libcpu.ctrl_word import CtrlWord

if __name__ == "__main__":
    cw = CtrlWord()
    #cw.c_word = 0x17d558f9
    cw.c_word = 0x07ff58ff

    for name, pin in all_pins():
        if cw.is_enabled(pin):
            print(pin)