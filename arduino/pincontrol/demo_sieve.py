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

    seg0 = 0x80     # location in RAM, 16 bytes

    p = 0x80        # first 2 bytes of seg0 is never accessed, reuse them
    m = 0x81

    ldi (A, 2)

    # fill seg0 with non-zero values
    while True:
        # calculate target address of seg0[A] in B
        ldi (B, seg0)
        add (B, A)

        stabs (B, A) # store "something" there (any non-zero value will do)

        # next index in A
        ldi (B, 1)
        add (A, B)

        # are we done?
        ldi (B, 16)
        cmp (A, B)

        # emulate conditional jump back to start of the loop
        if bne(): continue
        break


    ldi (A, 2)

    while True:
        st (p, A)   # store for later

        # calculate flags for seg0[A]
        ldi (B, seg0)
        add (B, A)
        tstabs (B) # test byte in RAM

        if not beq(): # emulate jumping over block

            print ("Prime found: {}".format(out(A)))

            # start from next multiple
            mov (B, A)
            add (A, B)

            while True:

                # less than 16?
                ldi (B, 16)
                cmp (A, B)
                if bcc(): break

                # store for later
                st (m, A)

                # write zero at seg0[A]
                ldi (B, seg0)
                add (B, A)
                ldi (A, 0)
                stabs (B, A)

                # reload stored values and calculate
                # next multiple
                ld (A, m)
                ld (B, p)
                add (A, B)


        # next index in A
        ld (A, p)
        ldi (B, 1)
        add (A, B)

        # are we done?
        ldi (B, 16)
        cmp (A, B)

        if bne(): continue
        break



if __name__ == "__main__":

    # PySerial is not ready directly after connecting
    # try a single operation before proceeding with tests
    pins.identify()
    asm.export_isa(cpu, globals())
    run()
