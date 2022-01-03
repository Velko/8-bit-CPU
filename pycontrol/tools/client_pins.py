#!/usr/bin/python3

import sys, cmd
import localpath
from typing import Dict, Sequence
from libcpu.util import unwrap
from libcpu.pinclient import PinClient

from libcpu.PyAsmExec import setup_live
backend = setup_live()

from libcpu import DeviceSetup, devices
from libcpu.pin import PinBase, Pin, MuxPin
from libcpu.discovery import all_pins
from libcpu.util import UninitializedError

pin_map: Dict[str, PinBase] = dict()

class Unsupported(Exception): pass

class TesterClient(cmd.Cmd):

    def complete_pin(self, text: str, line: str, begidx: int, endidx: int) -> Sequence[str]:
        return list(filter(lambda n: n.startswith(text), pin_map.keys()))

    def complete_pin_direct(self, text: str, line: str, begidx: int, endidx: int) -> Sequence[str]:
        return list(filter(lambda n: n.startswith(text) and isinstance(pin_map[n], Pin), pin_map.keys()))

    def do_EOF(self, arg: str) -> None:
        backend.client.close()
        sys.exit(0)

    def do_identify(self, arg: str) -> None:
        'Identify device'
        chr = backend.client.identify()
        print (chr)

    def do_off(self, arg: str) -> None:
        'Turn everything off, release Bus'
        backend.control.reset()
        backend.client.off(backend.control.default)
        print(bin(backend.control.c_word))

    def do_send(self, arg: str) -> None:
        'Send value on to the Bus'
        backend.client.bus_set(arg)

    def do_bus(self, arg: str) -> None:
        'Read current value on the Bus'
        chr = backend.client.bus_get()
        print (chr)

    def do_release(self, arg: str) -> None:
        'Release bus'
        backend.client.bus_free()

    def do_flags(self, arg: str) -> None:
        'Read flags'
        print (backend.client.flags_get())

    def do_set(self, arg: str) -> None:
        'Set control pin ignoring active-high/low setting'
        if arg in pin_map:
            pin = pin_map[arg]
            if isinstance(pin, Pin):
                backend.control.set(pin.num)
            else:
                raise Unsupported
        else:
            backend.control.set(int(arg, 0))
        print(bin(backend.control.c_word))

    complete_set = complete_pin_direct

    def do_clr(self, arg: str) -> None:
        'Clear control pin ignoring active-high/low setting'
        if arg in pin_map:
            pin = pin_map[arg]
            if isinstance(pin, Pin):
                backend.control.clr(pin.num)
            else:
                raise Unsupported
        else:
            backend.control.clr(int(arg))
        print(bin(backend.control.c_word))

    complete_clr = complete_pin_direct

    def do_enable(self, arg: str) -> None:
        'Enable control pin according to active-high/low setting'
        pin_map[arg].enable()
        print(bin(backend.control.c_word))

    complete_enable = complete_pin

    def do_disable(self, arg: str) -> None:
        'Disable control pin according to active-high/low setting'
        pin_map[arg].disable()
        print(bin(backend.control.c_word))

    complete_disable = complete_pin

    def do_commit(self, arg: str) -> None:
        'Send the control word to Arduino'
        backend.client.ctrl_commit(backend.control.c_word)

    def do_pulse(self, arg: str) -> None:
        'Pulse normal clock'
        backend.client.clock_pulse()

    def do_inverted(self, arg: str) -> None:
        'Pulse inverted clock'
        backend.client.clock_inverted()

    def do_tick(self, arg: str) -> None:
        'Pulse both clocks'
        backend.client.clock_tick()

    def do_ir_get(self, arg: str) -> None:
        backend.control.reset()
        pin_map['irfetch.load'].enable()
        rv = backend.client.ir_get(backend.control.c_word)
        print (rv)


    def do_add_sample(self, arg: str) -> None:
        backend.client.off(backend.control.default)
        backend.client.bus_set(24)
        backend.control.clr(0)
        backend.client.ctrl_commit(backend.control.c_word)
        backend.client.clock_tick()
        backend.control.set(0)
        backend.control.clr(2)
        backend.client.ctrl_commit(backend.control.c_word)
        backend.client.bus_set(18)
        backend.client.clock_tick()
        backend.client.bus_free()
        backend.control.set(2)
        backend.control.clr(3)
        backend.client.ctrl_commit(backend.control.c_word)
        print(backend.client.bus_get())
        backend.control.set(3)
        backend.client.ctrl_commit(backend.control.c_word)

def build_pinmap() -> None:
    for name, attr in all_pins():
        pin_map[name.lower()] = attr


if __name__ == "__main__":

    build_pinmap()
    TesterClient().cmdloop()
