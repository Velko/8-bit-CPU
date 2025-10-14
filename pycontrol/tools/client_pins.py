#!/usr/bin/python3

import sys
import cmd
from collections.abc import Sequence

from libcpu.pinclient import get_client_instance
client = get_client_instance()

from libcpu.pin import Pin, SimplePin, Level, PinUsage
from libcpu.DeviceSetup import hardware as hw
from libcpu.ctrl_word import CtrlWord

pin_map: dict[str, Pin] = {}

class Unsupported(Exception):
    pass

class TesterClient(cmd.Cmd):

    def __init__(self) -> None:
        super().__init__()
        self.control = CtrlWord()

    def complete_pin(self, text: str, _line: str, _begidx: int, _endidx: int) -> Sequence[str]:
        return list(filter(lambda n: n.startswith(text), pin_map.keys()))

    def complete_pin_direct(self, text: str, _line: str, _begidx: int, _endidx: int) -> Sequence[str]:
        return list(filter(lambda n: n.startswith(text) and isinstance(pin_map[n], SimplePin), pin_map.keys()))

    def do_EOF(self, _arg: str) -> None:
        client.close()
        sys.exit(0)

    def do_identify(self, _arg: str) -> None:
        'Identify device'
        idstr = client.identify()
        print (idstr)

    def do_off(self, _arg: str) -> None:
        'Turn everything off, release Bus'
        self.control = CtrlWord()
        client.off()
        print(bin(self.control.c_word))

    def do_addr(self, arg: str) -> None:
        'Read/Send current value on the Address Bus'
        if arg:
            client.addr_set(arg)
        else:
            addr = client.addr_get()
            print (addr)

    def do_bus(self, arg: str) -> None:
        'Read/Send current value on the Main Bus'
        if arg:
            client.bus_set(arg)
        else:
            value = client.bus_get()
            print (value)

    def do_release(self, _arg: str) -> None:
        'Release bus'
        client.bus_free()

    def do_flags(self, _arg: str) -> None:
        'Read flags'
        print (client.flags_get())

    def do_set(self, arg: str) -> None:
        'Set control pin ignoring active-high/low setting'
        if arg in pin_map:
            pin = pin_map[arg]
            if isinstance(pin, SimplePin):
                # in order to always set, make an active-high copy of the pin
                high_pin = SimplePin(pin.num, Level.HIGH, pin.usage)
                self.control.enable(high_pin)
            else:
                raise Unsupported
        else:
            # create an artificial pin for numeric
            high_pin = SimplePin(int(arg, 0), Level.HIGH, PinUsage.EXCLUSIVE)
            self.control.enable(high_pin)
        print(bin(self.control.c_word))

    complete_set = complete_pin_direct

    def do_clr(self, arg: str) -> None:
        'Clear control pin ignoring active-high/low setting'
        if arg in pin_map:
            pin = pin_map[arg]
            if isinstance(pin, SimplePin):
                # in order to always set, make an active-high copy of the pin
                high_pin = SimplePin(pin.num, Level.HIGH, pin.usage)
                self.control.disable(high_pin)
            else:
                raise Unsupported
        else:
            # create an artificial pin for numeric
            high_pin = SimplePin(int(arg, 0), Level.HIGH, PinUsage.EXCLUSIVE)
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

    def do_commit(self, _arg: str) -> None:
        'Send the control word to Arduino'
        client.ctrl_commit(self.control)

    def do_pulse(self, _arg: str) -> None:
        'Pulse normal clock'
        client.clock_pulse()

    def do_inverted(self, _arg: str) -> None:
        'Pulse inverted clock'
        client.clock_inverted()

    def do_tick(self, _arg: str) -> None:
        'Pulse both clocks'
        client.clock_tick()

    def do_ir_get(self, _arg: str) -> None:
        rv = client.ir_get()
        print (rv)


    def do_reset(self, _arg: str) -> None:
        self.control = CtrlWord()
        client.off()
        client.reset()

    def do_shutdown(self, _arg: str) -> None:
        client.shutdown()

def build_pinmap() -> None:
    for name, attr in hw.all_pins():
        pin_map[name.lower()] = attr


if __name__ == "__main__":

    build_pinmap()
    TesterClient().cmdloop()
