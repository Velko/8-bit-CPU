#!/usr/bin/env python3

import localpath

from typing import BinaryIO, Iterator, Sequence
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

def generate_microcode(rom: BinaryIO, rom_idx: int) -> None:
    for microcode in opcodes.values():
        for flags in range(16):
            process_steps(rom, rom_idx, microcode, flags)

def process_steps(rom: BinaryIO, rom_idx: int, microcode: MicroCode, flags: int) -> None:
    for pins in finalize_steps(microcode, flags):
        control.reset()
        for pin in pins:
            pin.enable()

        rom.write(bytes([control.c_word >> (rom_idx << 3) & 0xFF]))


if __name__ == "__main__":
    with open("rom0.bin", "wb") as f:
        generate_microcode(f, 0)

    with open("rom1.bin", "wb") as f:
        generate_microcode(f, 1)

    with open("rom2.bin", "wb") as f:
        generate_microcode(f, 2)

    with open("rom3.bin", "wb") as f:
        generate_microcode(f, 3)
