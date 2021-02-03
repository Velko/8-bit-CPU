#!/usr/bin/python3

import localpath
from libcpu.cpu import *

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

    from libcpu.PyAsmExec import setup_live
    setup_live()
    run()
