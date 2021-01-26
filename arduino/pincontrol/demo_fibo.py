#!/usr/bin/python3

import sys, serial

from libpins import asm
from libpins.PinClient import PinClient
from libpins.cpu import CPU
from libpins.devices import Flags
from libpins.ctrl_word import CtrlWord

control = CtrlWord()

ser = serial.Serial("/dev/ttyACM0", 9600, timeout=3)
pins = PinClient(ser)
cpu = CPU(pins, control)


def run():
    ldi(A, 0)
    ldi(B, 1)

    out(A)
    out(B)

    while True:
        add(A, B)
        if bcs(): break;
        out(A)

        add(B, A)
        if bcs(): break;
        out(B)


if __name__ == "__main__":

    # PySerial is not ready directly after connecting
    # try a single operation before proceeding with tests
    pins.identify()
    asm.export_isa(cpu, globals())
    run()
