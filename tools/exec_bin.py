#!/usr/bin/python3


import sys
import argparse
import localpath
localpath.install()
from libcpu.util import OutMessage, HaltMessage, BrkMessage
from libcpu.pinclient import get_client_instance
from libcpu.cpu_helper import CPUHelper

cpu_helper: CPUHelper = CPUHelper(get_client_instance())

RAM_OFFSET = 0x0000

def upload(filename: str) -> None:

    with open(filename, "rb") as f:
        binary = f.read()

    print (f"# Uploading {filename} ", end="", flush=True, file=sys.stderr)

    for addr, byte in enumerate(binary):
        cpu_helper.write_ram(addr + RAM_OFFSET, byte)

        print (".", end="", flush=True, file=sys.stderr)

    print (" OK", file=sys.stderr)



def run() -> None:

    # Drumroll... now it should happen for real
    print ("# Running ...", flush=True, file=sys.stderr)

    cpu_helper.client.run_program()
    out = cpu_helper.client.receive_messages()

    for msg in out:
        match msg:
            case HaltMessage():
                print ("# Halted", flush=True, file=sys.stderr)
                break

            case BrkMessage():
                print ("# Break", flush=True, file=sys.stderr)
                break

            case OutMessage(payload):
                print(payload, end="", flush=True)

def monitor() -> None:
    print ("# Running (raw)...", flush=True, file=sys.stderr)
    cpu_helper.client.run_program()
    for line in cpu_helper.client.receive_lines():
        print(line)
        if line.endswith("#HLT"):
            print ("# Halted", flush=True, file=sys.stderr)
            return

if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        prog="exec_bin",
        description="Uploads, starts and monitors a program on the 8-bit CPU"
    )

    parser.add_argument("filename")
    parser.add_argument("-u", "--upload-only", action="store_true", help="upload binary and reset CPU, do not start the program")
    parser.add_argument("-M", "--monitor", action="store_true", help="listen for raw UART communication")

    args = parser.parse_args()

    upload(args.filename)
    cpu_helper.client.reset()
    if args.monitor:
        monitor()
    elif not args.upload_only:
        run()
