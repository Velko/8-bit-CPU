#!/usr/bin/python3

import sys, cmd
import localpath
from typing import Dict, Sequence

from libcpu.cpu import setup_live
backend = setup_live()

from libcpu.pin import Pin, SimplePin, Level
from libcpu.discovery import all_pins
from libcpu.ctrl_word import CtrlWord, DEFAULT_CW

pin_map: Dict[str, Pin] = dict()

class Unsupported(Exception): pass

class TesterClient(cmd.Cmd):

    def __init__(self) -> None:
        super().__init__()
        self.control = CtrlWord()

    def complete_pin(self, text: str, line: str, begidx: int, endidx: int) -> Sequence[str]:
        return list(filter(lambda n: n.startswith(text), pin_map.keys()))

    def complete_pin_direct(self, text: str, line: str, begidx: int, endidx: int) -> Sequence[str]:
        return list(filter(lambda n: n.startswith(text) and isinstance(pin_map[n], SimplePin), pin_map.keys()))

    def do_EOF(self, arg: str) -> None:
        backend.client.close()
        sys.exit(0)

    def do_identify(self, arg: str) -> None:
        'Identify device'
        chr = backend.client.identify()
        print (chr)

    def do_off(self, arg: str) -> None:
        'Turn everything off, release Bus'
        self.control = CtrlWord()
        backend.client.off(DEFAULT_CW.c_word)
        print(bin(self.control.c_word))

    def do_addr(self, arg: str) -> None:
        'Read/Send current value on the Address Bus'
        if arg:
            backend.client.addr_set(arg)
        else:
            chr = backend.client.addr_get()
            print (chr)

    def do_bus(self, arg: str) -> None:
        'Read/Send current value on the Main Bus'
        if arg:
            backend.client.bus_set(arg)
        else:
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
            if isinstance(pin, SimplePin):
                # in order to always set, make an active-high copy of the pin
                high_pin = SimplePin(pin.num, Level.HIGH)
                self.control.enable(high_pin)
            else:
                raise Unsupported
        else:
            # create an artificial pin for numeric
            high_pin = SimplePin(int(arg, 0), Level.HIGH)
            self.control.enable(high_pin)
        print(bin(self.control.c_word))

    complete_set = complete_pin_direct

    def do_clr(self, arg: str) -> None:
        'Clear control pin ignoring active-high/low setting'
        if arg in pin_map:
            pin = pin_map[arg]
            if isinstance(pin, SimplePin):
                # in order to always set, make an active-high copy of the pin
                high_pin = SimplePin(pin.num, Level.HIGH)
                self.control.disable(high_pin)
            else:
                raise Unsupported
        else:
            # create an artificial pin for numeric
            high_pin = SimplePin(int(arg, 0), Level.HIGH)
            self.control.disable(high_pin)
        print(bin(self.control.c_word))

    complete_clr = complete_pin_direct

    def do_enable(self, arg: str) -> None:
        'Enable control pin according to active-high/low setting'
        self.control.enable(pin_map[arg])
        print(bin(self.control.c_word))

    complete_enable = complete_pin

    def do_disable(self, arg: str) -> None:
        'Disable control pin according to active-high/low setting'
        self.control.disable(pin_map[arg])
        print(bin(self.control.c_word))

    complete_disable = complete_pin

    def do_commit(self, arg: str) -> None:
        'Send the control word to Arduino'
        backend.client.ctrl_commit(self.control.c_word)

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
        rv = backend.client.ir_get()
        print (rv)


    def do_reset(self, arg: str) -> None:
        self.control = CtrlWord()
        backend.client.off(DEFAULT_CW.c_word)
        backend.client.reset()

    def do_shutdown(self, arg: str) -> None:
        backend.client.shutdown()

def build_pinmap() -> None:
    for name, attr in all_pins():
        pin_map[name.lower()] = attr


if __name__ == "__main__":

    build_pinmap()
    TesterClient().cmdloop()
