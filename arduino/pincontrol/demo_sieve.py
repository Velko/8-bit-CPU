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
    seg_n = 0x90    # next 16 bytes - segment calc
    r_low = 0xA0


    print ("-------- segment: 0 (simple) -------", flush=True)

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


    # Simple sieve for first 16
    ldi (A, 2)

    while True:
        st (p, A)   # store for later

        # calculate flags for seg0[A]
        ldi (B, seg0)
        add (B, A)
        tstabs (B) # test byte in RAM

        if not beq(): # emulate jumping over block

            out(A)

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

    # Continue with segmented sieve
    ldi (A, 16)

    while True:
        st (r_low, A)
        print ("----------- segment: {}+ -----------".format(peek(A)), flush=True)

        # Fill seg_n with non-zeros
        ldi (A, 0)
        while True:
            # write non-zero in seg_n[A]
            ldi (B, seg_n)
            add (B, A)

            stabs(B, B) # can not write A, as it may be zero this time

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
            st (p, A) # save for later

            # test if seg0[A] != 0 meaning that A is prime
            ldi (B, seg0)
            add (B, A)
            tstabs (B)

            if not beq():   # jump over if not prime

                # add p to m until get in range of current segment
                while True:
                    ld (B, p)
                    add (A, B)

                    # A smaller that r_low?
                    ld (B, r_low)
                    cmp (A, B)

                    if bcs(): continue
                    break

                # subtract, so that A becomes an index in seg_n[]
                ld (B, r_low)
                sub (A, B)

                while True:
                    # check at the beginning, because A could already
                    # be >= 16
                    ldi (B, 16)
                    cmp (A, B)
                    if bcc(): break

                    # store, as we will need A for other purposes
                    st (m, A)

                    # address of seg_n[A]
                    ldi (B, seg_n)
                    add (B, A)

                    # write a zero over it
                    ldi (A, 0)
                    stabs (B, A)

                    # reload A and add p for next multiple
                    ld (A, m)
                    ld (B, p)
                    add (A, B)


            # next index in seg0
            ld (A, p)
            ldi (B, 1)
            add (A, B)

            # done with seg0?
            ldi (B, 16)
            cmp (A, B)

            # next iteration
            if bne(): continue
            break

        # segment done, print it out
        ldi (A, 0)
        while True:

            # check byte at seg_n[A]
            ldi (B, seg_n)
            add (B, A)
            tstabs(B)

            if not beq():

                # add r_low to get real number
                ld (B, r_low)
                add (B, A)

                out(B)

            # next index in A
            ldi (B, 1)
            add (A, B)

            # are we done?
            ldi (B, 16)
            cmp (A, B)

            if bne(): continue
            break


        # next segment
        ld (A, r_low)
        ldi (B, 16)
        add (A, B)

        # all done
        if bcc(): continue
        break


        print ("----------- done -----------", flush=True)

if __name__ == "__main__":

    # PySerial is not ready directly after connecting
    # try a single operation before proceeding with tests
    pins.identify()
    asm.export_isa(cpu, globals())
    run()
