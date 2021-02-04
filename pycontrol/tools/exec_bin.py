#!/usr/bin/python3

import localpath
from libcpu.PyAsmExec import setup_live, control
setup_live()
from libcpu.PyAsmExec import pins

from libcpu.DeviceSetup import ProgMem, IRFetch, Clock
from libcpu.cpu import *
from libcpu.opcodes import fetch, opcodes

def upload():

    with open("sieve.bin", "rb") as f:
        binary = f.read()

    print ("Uploading ", end="", flush=True)

    for addr, byte in enumerate(binary):
        ldi (A, byte)
        st (addr, A)
        print (".", end="", flush=True)

    print (" OK")



def run():
    # Reset PC and detach hooks for immediate value handling
    jmp (0)
    ProgMem.unhook_all()

    # prepare control word for IRFetch
    control.reset()
    IRFetch.load.enable()
    irf_word = control.c_word

    # extract microcode in list so that we can access it by
    # numeric opcode
    ops_by_num = list(opcodes.values())

    # Drumroll... now it should happen for real
    print ("Running ...", flush=True)

    while True:
        # fetch the instruction
        for step in fetch.steps(None):
            control.reset()
            for pin in step:
                pin.enable()
            pins.ctrl_commit(control.c_word)
            pins.clock_tick()

        # load opcode from IR register and flags
        opcode = pins.ir_get(irf_word)
        flags = pins.flags_get()

        # apply all steps
        microcode = ops_by_num[opcode]
        for step in microcode.steps(flags):

            # set up and send control word
            control.reset()
            for pin in step:
                pin.enable()
            pins.ctrl_commit(control.c_word)

            # pulse a clock
            if OutPort.load.is_enabled():
                # special handling for OutPort: intercept
                # the value and print it out here as well
                pins.clock_pulse()
                out_val = pins.bus_get()
                pins.clock_inverted()
                print (out_val, flush=True)
            else:
                pins.clock_tick()

            # are we done?
            if Clock.halt.is_enabled():
                print ("Halted", flush=True)
                return


if __name__ == "__main__":
    upload()
    run()
