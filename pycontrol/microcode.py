#!/usr/bin/env python3

from libcpu.cpu_exec import opcodes
from libcpu import cpu

from libcpu.devices import Flags
from libcpu.ctrl_word import CtrlWord
from libcpu.cpu_exec import CPUBackendControl

control = CtrlWord()

class FakeClient:
    def bus_set(self, arg):
        pass

pins = FakeClient()
cpu.install_cpu_backend(CPUBackendControl(pins, control))

def generate_microcode():
    for key, microcode in opcodes.items():
        if microcode.is_flag_dependent():
            for f in range(16):
                process_steps(key, microcode, f)
        else:
            process_steps(key, microcode, None)


def process_steps(key, microcode, flags):
    for step, pins in enumerate(microcode.steps(flags)):
        control.reset()
        for pin in pins:
            pin.enable()

        if flags is None:
            flags = 0

        print ("{0:13}    {1:04b}  {2}  {3:016b}    {3:04x}".format(key, flags, step, control.c_word))


if __name__ == "__main__":
    generate_microcode()
