#!/usr/bin/env python3

import localpath

from typing import Iterator, Sequence
from libcpu.opcode_builder import MicroCode
from libcpu.util import ControlSignal
from libcpu.opcodes import opcodes, fetch
from libcpu.DeviceSetup import StepCounter

from libcpu.ctrl_word import CtrlWord

MAX_STEPS=8

control = CtrlWord()

def finalize_steps(microcode: MicroCode, flags: int) -> Iterator[Sequence[ControlSignal]]:

    # fetch stage
    for f_step in fetch:
        yield f_step

    # steps from microcode definition, up to MAX
    for s_idx in range(MAX_STEPS-len(fetch)):
        step, is_last = microcode.get_step(s_idx, flags)
        if is_last:
            # add Steps.reset at last relevant step
            yield list(step) + [StepCounter.reset]
        else:
            yield step

def generate_microcode() -> None:
    for mnemonic, microcode in opcodes.items():
        for flags in range(16):
            process_steps(mnemonic, microcode, flags)

def process_steps(key: str, microcode: MicroCode, flags: int) -> None:
    for step, pins in enumerate(finalize_steps(microcode, flags)):
        control.reset()
        for pin in pins:
            #if pin == StepCounter.reset: print ("Reset")
            pin.enable()

        print ("{0:13} {4:02x}   {1:04b}  {2}  {3:016b}    {3:04x}".format(key, flags, step, control.c_word, microcode.opcode))


if __name__ == "__main__":
    generate_microcode()
