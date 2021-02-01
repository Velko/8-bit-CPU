#!/usr/bin/python3

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

    from libcpu import PyAsmExec

    PyAsmExec.setup()
    run()
