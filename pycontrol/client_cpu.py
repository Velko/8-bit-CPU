#!/usr/bin/python3

import sys, cmd
import localpath

from libcpu.util import unwrap
from libcpu.cpu import *
from libcpu.devices import Flags
from libcpu.DeviceSetup import Mar, Ram
from libcpu.PyAsmExec import setup_live, control
setup_live()
from libcpu.PyAsmExec import pins

client = unwrap(pins)

class TesterClient(cmd.Cmd):

    def do_EOF(self, arg: str) -> None:
        client.close()
        sys.exit(0)

    def do_identify(self, arg: str) -> None:
        'Identify device'
        chr = client.identify()
        print (chr)

    def do_off(self, arg: str) -> None:
        control.reset()
        client.off(control.default)
        print (bin(control.default))

    def do_load_a(self, arg: str) -> None:
        ldi(A, int(arg, 0))

    def do_load_b(self, arg: str) -> None:
        ldi(B, int(arg, 0))

    def do_load_f(self, arg: str) -> None:
        ldi(F, int(arg, 0))

    def do_add_ab(self, arg: str) -> None:
        add(A, B)

    def do_add_ba(self, arg: str) -> None:
        add(B, A)

    def do_sub_ab(self, arg: str) -> None:
        sub(A, B)

    def do_out_a(self, arg: str) -> None:
        out(A)

    def do_out_b(self, arg: str) -> None:
        out(B)

    def do_flags_get(self, arg: str) -> None:
        val = client.flags_get()
        print (Flags.decode(val))

    def do_load_mar(self, arg: str) -> None:
        control.reset()
        Mar.load.enable()
        client.bus_set(arg)
        client.ctrl_commit(control.c_word)
        client.clock_tick()

        control.reset()
        client.off(control.default)

    def do_write_ram(self, arg: str) -> None:
        Ram.write.enable()
        client.bus_set(arg)
        client.ctrl_commit(control.c_word)

        client.clock_tick()

        control.reset()
        client.off(control.default)

    def do_read_ram(self, arg: str) -> None:
        Ram.out.enable()

        client.ctrl_commit(control.c_word)
        val = client.bus_get()

        control.reset()
        client.off(control.default)

        print (hex(val))

    def do_run(self, arg: str) -> None:
        try:
            for line in client.run_program():
                print (line, end="", flush=True)
        except KeyboardInterrupt:
            pass

    def do_upload(self, arg: str) -> None:
        with open(arg, "rb") as f:
            for addr, data in enumerate(f.read()):
                control.reset()
                Mar.load.enable()
                client.bus_set(addr)
                client.ctrl_commit(control.c_word)
                client.clock_tick()
                control.reset()

                Ram.write.enable()
                client.bus_set(data)
                client.ctrl_commit(control.c_word)
                client.clock_tick()

                control.reset()
                client.off(control.default)
                print (".", end="", flush=True)
        print ()


if __name__ == "__main__":

    TesterClient().cmdloop()
