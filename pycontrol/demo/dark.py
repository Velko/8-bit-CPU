#!/usr/bin/python3

import localpath
from libcpu.cpu import *

def run():

    # "Low power mode" - turn off as many LEDs as
    # possible
    ldi (A, 1)
    ldi (B, 0)
    add (A, B)

    stabs(B, B)

    mov (A, B)

if __name__ == "__main__":

    from libcpu.PyAsmExec import setup_live
    setup_live()
    run()
