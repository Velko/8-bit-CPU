#!/usr/bin/env python3

from libpins.cpu import CPU, opcodes
from libpins.devices import Flags
from libpins.ctrl_word import CtrlWord

control = CtrlWord()

class FakeClient:
    def bus_set(self, arg):
        pass

pins = FakeClient()
cpu = CPU(pins, control)

def generate_microcode():
    for key, microcode in opcodes.items():

        for pins in microcode:
            control.reset()
            for pin in pins:
                pin.enable()

            print ("{0:13}{1:013b}    {1:04x}".format(key, control.c_word))



if __name__ == "__main__":
    generate_microcode()
