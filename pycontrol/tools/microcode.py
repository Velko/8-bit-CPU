#!/usr/bin/env python3

import localpath

from typing import Iterator, Sequence
from libcpu.opcode_builder import MicroCode
from libcpu.util import ControlSignal
from libcpu.opcodes import opcodes, fetch

from libcpu.ctrl_word import CtrlWord

control = CtrlWord()

def finalize_steps(microcode: MicroCode, flags: int) -> Iterator[Sequence[ControlSignal]]:

    # fetch stage
    for f_step in fetch:
        yield f_step

    for s_idx in range(8-len(fetch)):
        step = microcode.get_step(s_idx, flags)
        if step is not None:
            yield step
        else:
            yield []

def generate_microcode() -> None:
    for key, microcode in opcodes.items():
        for f in range(16):
            process_steps(key, microcode, f)

def process_steps(key: str, microcode: MicroCode, flags: int) -> None:
    for step, pins in enumerate(finalize_steps(microcode, flags)):
        control.reset()
        for pin in pins:
            pin.enable()

        print ("{0:13} {4:02x}   {1:04b}  {2}  {3:016b}    {3:04x}".format(key, flags, step, control.c_word, microcode.opcode))


if __name__ == "__main__":
    generate_microcode()
