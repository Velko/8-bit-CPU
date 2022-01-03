#!/usr/bin/python3


import sys, localpath
from libcpu.pinclient import RunMessage
from libcpu.cpu import setup_live
from libcpu.DeviceSetup import PC
from libcpu.test_helpers import CPUHelper

cpu_helper: CPUHelper = CPUHelper(setup_live())

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

    out = cpu_helper.backend.client.run_program();

    for msg in out:

        if msg.reason == RunMessage.Reason.HALT:
            print ("# Halted", flush=True, file=sys.stderr)
            break

        elif msg.reason == RunMessage.Reason.BRK:
            print ("# Break", flush=True, file=sys.stderr)
            break

        elif msg.reason == RunMessage.Reason.OUT:
            print(msg.payload, end="", flush=True)


if __name__ == "__main__":
    upload()
    run()
