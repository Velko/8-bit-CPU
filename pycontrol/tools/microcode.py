#!/usr/bin/env python3

import localpath

from libcpu.opcodes import opcodes, fetch
from libcpu import cpu

from libcpu.devices import Flags
from libcpu.ctrl_word import CtrlWord
from libcpu.cpu_exec import CPUBackendControl
from libcpu.DeviceSetup import StepCounter

control = CtrlWord()

class FakeClient:
    def bus_set(self, arg):
        pass

pins = FakeClient()
cpu.install_cpu_backend(CPUBackendControl(pins, control))


def finalize_steps(steps):

    # prepend fetch stage
    work_steps = fetch.steps(None) + steps

    # patch last "meaningful" step to reset step counter
    work_steps[-1].append(StepCounter.reset)

    # list of empty lists to pad total count to 8
    padding = [[]] * (8 - len(work_steps))

    return work_steps + padding

def generate_microcode():
    for key, microcode in opcodes.items():
        for f in range(16):
            process_steps(key, microcode, f)


def process_steps(key, microcode, flags):
    for step, pins in enumerate(finalize_steps(microcode.steps(flags))):
        control.reset()
        for pin in pins:
            pin.enable()

        print ("{0:13} {4:02x}   {1:04b}  {2}  {3:016b}    {3:04x}".format(key, flags, step, control.c_word, microcode.opcode))


if __name__ == "__main__":
    generate_microcode()
