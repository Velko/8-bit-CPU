#!/usr/bin/python3


import sys, localpath
localpath.install()
from libcpu.util import RunMessage
from libcpu.pinclient import get_client_instance
from libcpu.cpu_helper import CPUHelper

cpu_helper: CPUHelper = CPUHelper(get_client_instance())

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
    cpu_helper.client.reset()

    # Drumroll... now it should happen for real
    print ("# Running ...", flush=True, file=sys.stderr)

    out = cpu_helper.client.run_program();

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
