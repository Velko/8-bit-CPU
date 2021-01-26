#!/usr/bin/python3

def run():

    # "Low power mode" - turn off as most LEDs as
    # possible
    ldi (A, 1)
    ldi (B, 0)
    add (A, B)

    stabs(B, B)

    mov (A, B)

if __name__ == "__main__":

    from libpins import PyAsmExec

    PyAsmExec.setup(globals())
    run()
