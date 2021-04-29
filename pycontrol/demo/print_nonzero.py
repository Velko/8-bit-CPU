#!/usr/bin/python3

import localpath
from libcpu.cpu import *

import random

def run():

    # fill memory with random garbage
    # ( not part of demo algorithm)
    for addr in range(32):
        ldi (A, random.randrange(256) & 0xa5)
        st (addr + data.start, A)


    # initialize i = 0, store it
    ldi (A, 0)
    st (i, A)

    while True:
        # each iteration begins with A holding value of i

        # calculate address of data[i]
        ldi (B, data)
        add (B, A)

        # load value (flags are updated)
        ldabs (A, B)

        # output if non-zero
        if not beq():
            out(A)

        # A was changed by ldabs(), reload
        ld (A, i)

        # increment it (current ISA is a bit limited)
        ldi (B, 1)
        add (A, B)

        # store i for later
        st (i, A)

        # check if a < 32
        ldi (B, 32)
        cmp (A, B)

        # and jump back to start
        if bne(): continue
        break # or exit loop

    hlt()


data = Bytes(32)
i = Byte()

if __name__ == "__main__":

    from libcpu.PyAsmExec import setup_live
    setup_live()
    run()
