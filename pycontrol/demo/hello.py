#!/usr/bin/python3

import localpath
from libcpu.cpu import *
from libcpu.DeviceSetup import DP
from libcpu.markers import String

def run() -> None:

    lea(DP, message)
    ldi (B, 0)
    while True:
        ldrel (A, DP, B)
        if beq(): break
        cout (A)
        inc (B)



message = String("Hello, World!\n")

if __name__ == "__main__":

    from libcpu.PyAsmExec import setup_live, setup_data
    setup_live()
    setup_data(message)
    run()
