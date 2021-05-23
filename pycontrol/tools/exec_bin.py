#!/usr/bin/python3


import sys, localpath
from libcpu.PyAsmExec import setup_live
from libcpu.util import unwrap
setup_live(False)
from libcpu.PyAsmExec import pins
client = unwrap(pins)

from libcpu.DeviceSetup import COutPort, OutPort, PC, Clock
from libcpu.cpu import backend
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

    # Drumroll... now it should happen for real
    print ("# Running ...", flush=True, file=sys.stderr)

    while True:
        # fetch and execute an instruction
        outval = cpu_helper.backend.fetch_and_execute()

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
