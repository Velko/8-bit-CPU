#!/usr/bin/env python3

import localpath

from typing import List, Iterator, Sequence, TypeVar
from libcpu.opcode_builder import MicroCode
from libcpu.util import ControlSignal
from libcpu.opcodes import opcodes, fetch
from libcpu.DeviceSetup import StepCounter

from libcpu.ctrl_word import CtrlWord
from itertools import islice

MAX_STEPS=8

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

def generate_microcode() -> Iterator[int]:
    for microcode in opcodes.values():
        for flags in range(16):
            for c_word in process_steps(microcode, flags):
                yield c_word

    for _ in range(512 - len(opcodes)):
        for c_word in [0xFFFFFFFF] * 16 * MAX_STEPS:
            yield c_word


def process_steps(microcode: MicroCode, flags: int) -> Iterator[int]:
    for pins in finalize_steps(microcode, flags):
        control = CtrlWord()
        for pin in pins:
            control.enable(pin)

        yield control.c_word

T = TypeVar('T')

def split_chunks(seq: Sequence[T], size: int) -> Iterator[List[T]]:
    it = iter(seq)
    return iter(lambda: list(islice(it, size)), [])

def write_rom_file(words: Sequence[int], rom_idx: int) -> None:
    with open(f"../../include/control_rom{rom_idx}.bin", "wb") as bin_rom:
        for c_word in words:
            bin_rom.write(bytes([c_word >> (rom_idx << 3) & 0xFF]))

    with open(f"../../include/control_rom{rom_idx}.hex", "wt") as hex_rom:
        for chunk in split_chunks(words, 16):
            for c_word in chunk:
                b = c_word >> (rom_idx << 3) & 0xFF
                hex_rom.write(f"{b:02x} ")
            hex_rom.write("\n")


if __name__ == "__main__":

    ucode_words = list(generate_microcode())

    for rom_idx in range(4):
        write_rom_file(ucode_words, rom_idx);
