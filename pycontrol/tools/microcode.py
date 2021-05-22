#!/usr/bin/env python3

import localpath

from typing import Iterator, List, Sequence
from libcpu.opcode_builder import MicroCode
from libcpu.util import ControlSignal
from libcpu.opcodes import opcodes, fetch

from libcpu.ctrl_word import CtrlWord

control = CtrlWord()

def finalize_steps(steps: Iterator[Sequence[ControlSignal]]) -> Sequence[Sequence[ControlSignal]]:

    # prepend fetch stage
    work_steps = list(fetch.steps(lambda: 0)) + list(steps)

    # patch last "meaningful" step to reset step counter
    #work_steps[-1].append(StepCounter.reset)

    # list of empty lists to pad total count to 8
    padding: List[Sequence[ControlSignal]] = [[]] * (8 - len(work_steps))

    return work_steps + padding

def generate_microcode() -> None:
    for key, microcode in opcodes.items():
        for f in range(16):
            process_steps(key, microcode, f)


def process_steps(key: str, microcode: MicroCode, flags: int) -> None:
    for step, pins in enumerate(finalize_steps(microcode.steps(lambda: flags))):
        control.reset()
        for pin in pins:
            pin.enable()

        print ("{0:13} {4:02x}   {1:04b}  {2}  {3:016b}    {3:04x}".format(key, flags, step, control.c_word, microcode.opcode))


if __name__ == "__main__":
    generate_microcode()
