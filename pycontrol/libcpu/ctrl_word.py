#!/usr/bin/env python3

from .DeviceSetup import all_pins

class CtrlWord:
    def __init__(self):
        self.c_word = 0

        for pin in all_pins():
            pin.connect(self)
            pin.disable()

        self.default = self.c_word


    def set(self, pin):
        self.c_word |= 1 << pin

    def clr(self, pin):
        self.c_word &= ~(1 << pin)

    def reset(self):
        self.c_word = self.default
