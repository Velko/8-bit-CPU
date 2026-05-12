#!/usr/bin/python3


import sys, termios, tty, select, os
import argparse
from libcpu.messages import OutMessage, HaltMessage, BrkMessage
from libcpu.pinclient import get_client_instance
from libcpu.cpu_helper import CPUHelper

cpu_helper: CPUHelper = CPUHelper(get_client_instance())

RAM_OFFSET = 0x0000

def upload(filename: str) -> None:

    with open(filename, "rb") as f:
        binary = f.read()

    print (f"# Uploading {filename} ", file=sys.stderr)
    cpu_helper.ram.write(RAM_OFFSET, binary)



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

            case OutMessage(target, payload):
                print(msg.formatted(), end="", flush=True)

def monitor() -> None:
    print ("# Running (raw)...", flush=True, file=sys.stderr)
    cpu_helper.client.run_program()

    fd = sys.stdin.fileno()
    old = termios.tcgetattr(fd)

    try:
        tty.setraw(fd)
        while True:
            r, _, _ = select.select([sys.stdin, cpu_helper.client.serial], [], [])
            if sys.stdin in r:
                data = os.read(sys.stdin.fileno(), 32)
                if b'\x03' in data:  # Ctrl-C
                    return
                cpu_helper.client.send_raw(data)

            if cpu_helper.client.serial in r:
                text = cpu_helper.client.receive_raw()
                print(text, flush=True, end="")
                if text.endswith("#HLT\r\n"):
                    print ("# Halted", flush=True, file=sys.stderr, end="\r\n")
                    return
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old)

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
