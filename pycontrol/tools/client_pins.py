#!/usr/bin/python3

import sys, cmd
import localpath
from typing import Dict, Sequence
from libcpu.util import unwrap
from libcpu.pinclient import PinClient

from libcpu.PyAsmExec import setup_live, control
setup_live()
from libcpu.PyAsmExec import pins

client = unwrap(pins)

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
        if pins is not None:
            pins.close()
        sys.exit(0)

    def do_identify(self, arg: str) -> None:
        'Identify device'
        chr = client.identify()
        print (chr)

    def do_off(self, arg: str) -> None:
        'Turn everything off, release Bus'
        control.reset()
        client.off(control.default)
        print(bin(control.c_word))

    def do_send(self, arg: str) -> None:
        'Send value on to the Bus'
        client.bus_set(arg)

    def do_bus(self, arg: str) -> None:
        'Read current value on the Bus'
        chr = client.bus_get()
        print (chr)

    def do_release(self, arg: str) -> None:
        'Release bus'
        client.bus_free()

    def do_flags(self, arg: str) -> None:
        'Read flags'
        print (client.flags_get())

    def do_set(self, arg: str) -> None:
        'Set control pin ignoring active-high/low setting'
        if arg in pin_map:
            pin = pin_map[arg]
            if isinstance(pin, Pin):
                control.set(pin.num)
            else:
                raise Unsupported
        else:
            control.set(int(arg, 0))
        print(bin(control.c_word))

    complete_set = complete_pin_direct

    def do_clr(self, arg: str) -> None:
        'Clear control pin ignoring active-high/low setting'
        if arg in pin_map:
            pin = pin_map[arg]
            if isinstance(pin, Pin):
                control.clr(pin.num)
            else:
                raise Unsupported
        else:
            control.clr(int(arg))
        print(bin(control.c_word))

    complete_clr = complete_pin_direct

    def do_enable(self, arg: str) -> None:
        'Enable control pin according to active-high/low setting'
        pin_map[arg].enable()
        print(bin(control.c_word))

    complete_enable = complete_pin

    def do_disable(self, arg: str) -> None:
        'Disable control pin according to active-high/low setting'
        pin_map[arg].disable()
        print(bin(control.c_word))

    complete_disable = complete_pin

    def do_commit(self, arg: str) -> None:
        'Send the control word to Arduino'
        client.ctrl_commit(control.c_word)

    def do_pulse(self, arg: str) -> None:
        'Pulse normal clock'
        client.clock_pulse()

    def do_inverted(self, arg: str) -> None:
        'Pulse inverted clock'
        client.clock_inverted()

    def do_tick(self, arg: str) -> None:
        'Pulse both clocks'
        client.clock_tick()

    def do_ir_get(self, arg: str) -> None:
        control.reset()
        pin_map['irfetch.load'].enable()
        rv = client.ir_get(control.c_word)
        print (rv)


    def do_add_sample(self, arg: str) -> None:
        client.off(control.default)
        client.bus_set(24)
        control.clr(0)
        client.ctrl_commit(control.c_word)
        client.clock_tick()
        control.set(0)
        control.clr(2)
        client.ctrl_commit(control.c_word)
        client.bus_set(18)
        client.clock_tick()
        client.bus_free()
        control.set(2)
        control.clr(3)
        client.ctrl_commit(control.c_word)
        print(client.bus_get())
        control.set(3)
        client.ctrl_commit(control.c_word)

def build_pinmap() -> None:
    for name, attr in all_pins():
        pin_map[name.lower()] = attr


if __name__ == "__main__":

    build_pinmap()
    TesterClient().cmdloop()
