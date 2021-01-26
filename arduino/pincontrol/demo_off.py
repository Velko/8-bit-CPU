#!/usr/bin/python3

import sys, serial

from libpins import asm
from libpins.PinClient import PinClient
from libpins.cpu import CPU
from libpins.ctrl_word import CtrlWord

control = CtrlWord()

ser = serial.Serial("/dev/ttyACM0", 9600, timeout=3)
pins = PinClient(ser)
cpu = CPU(pins, control)


def run():

    # "Low power mode" - turn off as most LEDs as
    # possible
    ldi (A, 1)
    ldi (B, 0)
    add (A, B)

    stabs(B, B)

    mov (A, B)

if __name__ == "__main__":

    # PySerial is not ready directly after connecting
    # try a single operation before proceeding with tests
    pins.identify()
    asm.export_isa(cpu, globals())
    run()
