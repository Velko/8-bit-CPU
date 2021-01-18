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
    for key, pins in opcodes.items():

        for pin in pins:
            pin.enable()

        print ("{0:12}{1:010b}    {1:03x}".format(key, control.c_word))

        control.reset()


if __name__ == "__main__":
    generate_microcode()
