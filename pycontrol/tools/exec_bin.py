#!/usr/bin/python3


import sys, localpath
from libcpu.PyAsmExec import setup_live, control
from libcpu.util import unwrap
setup_live(False)
from libcpu.PyAsmExec import pins
client = unwrap(pins)

from libcpu.DeviceSetup import COutPort, OutPort, PC, IRFetch, Clock
from libcpu.cpu import C, backend
from libcpu.opcodes import fetch
from libcpu.test_helpers import CPUHelper

cpu_helper: CPUHelper = CPUHelper(backend)

def upload() -> None:

    with open(sys.argv[1], "rb") as f:
        binary = f.read()

    print ("# Uploading ", end="", flush=True, file=sys.stderr)

    for addr, byte in enumerate(binary):
        cpu_helper.write_ram(addr, byte)

        print (".", end="", flush=True, file=sys.stderr)

    print (" OK", file=sys.stderr)



def run() -> None:

    # Reset PC
    cpu_helper.load_reg16(PC, 0)

    # prepare control word for IRFetch
    control.reset()
    IRFetch.load.enable()
    irf_word = control.c_word

    # Drumroll... now it should happen for real
    print ("# Running ...", flush=True, file=sys.stderr)

    while True:
        # fetch the instruction
        cpu_helper.backend.execute_microcode(fetch)

        # load opcode from IR register and flags
        opcode = client.ir_get(irf_word)

        # apply all steps
        _, outval = cpu_helper.backend.execute_opcode(opcode)

        # are we done?
        if Clock.halt.is_enabled():
            print ("# Halted", flush=True, file=sys.stderr)
            return

        # catch output value
        if OutPort.load.is_enabled():
            print (outval, flush=True)
        if COutPort.load.is_enabled():
            print (chr(outval), end="", flush=True)


if __name__ == "__main__":
    upload()
    run()
