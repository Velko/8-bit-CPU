#!/usr/bin/python3


from dataclasses import dataclass
import sys, termios, tty, select, os
import argparse
from typing import Generator
from libcpu.messages import OutMessage, HaltMessage, BrkMessage, RunMessage
from libcpu.pinclient import PinClient, get_client_instance
from libcpu.cpu_helper import CPUHelper
from libcpu.pretty import format_message
from libcpu.uart_channel import UARTChannel

cpu_helper: CPUHelper = CPUHelper(get_client_instance())
uart = UARTChannel()

RAM_OFFSET = 0x0000

def upload(filename: str) -> None:

    with open(filename, "rb") as f:
        binary = f.read()

    print (f"# Uploading {filename} ", file=sys.stderr)
    cpu_helper.ram.write(RAM_OFFSET, binary)


def handle_message(msg: RunMessage) -> bool:
    match msg:
        case HaltMessage():
            print ("# Halted", flush=True, file=sys.stderr, end="\r\n")
            return False

        case BrkMessage():
            print ("# Break", flush=True, file=sys.stderr, end="\r\n")
            return False

        case OutMessage(target, payload):
            if sys.stdout.isatty():
                print(format_message(target, payload), end="", flush=True)
            else:
                print(payload, end="", flush=True)

    return True

def run(interactive: bool) -> None:
    cpu_helper.client.register_endpoint(2, uart.get_port())

    print ("# Running (raw)...", flush=True, file=sys.stderr)
    cpu_helper.client.run_program()

    fd = sys.stdin.fileno()
    if interactive:
        old = termios.tcgetattr(fd)
        tty.setraw(fd)

    streams = [sys.stdin, cpu_helper.client.transport, uart.transport]

    try:
        while True:
            r, _, _ = select.select(streams, [], [])
            if sys.stdin in r:
                data = os.read(sys.stdin.fileno(), 32)
                if not data:
                    print ("# EOF", flush=True, file=sys.stderr, end="\r\n")
                    streams.remove(sys.stdin)
                    continue
                if b'\x03' in data:  # Ctrl-C
                    print ("# Interrupted", flush=True, file=sys.stderr, end="\r\n")
                    return
                uart.send(data)

            if cpu_helper.client.transport in r:
                message = cpu_helper.client.receive_message()
                if not handle_message(message):
                    return

            if uart.transport in r:
                text = uart.receive()
                print(text, flush=True, end="")
    finally:
        if interactive:
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
        run(sys.stdin.isatty())
    elif not args.upload_only:
        run(False)
