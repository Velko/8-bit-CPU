#!/usr/bin/python3

from libcpu.cpu import *

def run():

    # "Low power mode" - turn off as most LEDs as
    # possible
    ldi (A, 1)
    ldi (B, 0)
    add (A, B)

    stabs(B, B)

    mov (A, B)

if __name__ == "__main__":

    from libcpu import PyAsmExec

    PyAsmExec.setup()
    run()
