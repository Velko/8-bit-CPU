#!/usr/bin/env python3

import localpath

from libcpu.opcodes import opcodes, fetch
from libcpu.util import ControlSignal
from libcpu.devices import Flags
from libcpu.pin import Pin, MuxPin, Level, Mux
from libcpu.discovery import all_pins, all_muxes

from typing import TextIO, Iterable, Iterator

from libcpu.ctrl_word import CtrlWord

CWORD_WIDTH_BYTES = 4

CWORD_WIDTH_BITS = CWORD_WIDTH_BYTES * 8

control = CtrlWord()


def generate_microcode(cfile: TextIO) -> None:
    cfile.write ("#include \"microcode.h\"\n\n")

    words = process_steps(fetch)
    cfile.write ("const cword_t op_fetch[] = {{{}}};\n\n".format(", ".join(words)))

    cfile.write ("const struct op_microcode microcode[] PROGMEM = {\n")


    for key, microcode in opcodes.items():

        words = process_steps(microcode._steps)
        cfile.write ("\n    /* {:02x} {:10} */\n".format(microcode.opcode, key))
        cfile.write ("    {{ .default_steps = {{{}}},".format(", ".join(words)))

        if not microcode.f_alt:
            cfile.write ("},\n")
            continue

        cfile.write ("\n      .f_alt = {\n")

        for alt in microcode.f_alt:
            words = process_steps(alt.steps)
            cfile.write ("          /* mask: {} value: {} */\n".format(Flags.decode(alt.mask), Flags.decode(alt.value)))
            cfile.write ("          {{ .mask = 0x{:02x}, .value = 0x{:02x},\n".format(alt.mask, alt.value))
            cfile.write ("            .steps = {{{}}},\n".format(", ".join(words)))
            cfile.write ("          },\n")

            cfile.write ("      },\n")
        cfile.write ("    },\n")

    cfile.write ("};\n")

def process_steps(steps: Iterable[Iterable[ControlSignal]]) -> Iterator[str]:
    for pins in steps:
        control.reset()
        for pin in pins:
            pin.enable()

        yield "0x{word:0{digits}x}".format(word=control.c_word, digits=CWORD_WIDTH_BYTES * 2)

def write_header(hfile: TextIO) -> None:
    hfile.write("#ifndef OP_DEFS_H\n")
    hfile.write("#define OP_DEFS_H\n\n")

def write_footer(hfile: TextIO) -> None:
    hfile.write("#endif /* OP_DEFS_H */\n")

def write_opcodes(hfile: TextIO) -> None:
    hfile.write("/* Opcodes */\n")
    for key, microcode in opcodes.items():
        name = key.upper()

        hfile.write("#define OP_{:20}0x{:02x}\n".format(name, microcode.opcode))

    hfile.write("#define NUM_OPS                {:02}\n".format(len(opcodes)))

    hfile.write("\n")

def write_default_cword(hfile: TextIO) -> None:
    control.reset()

    hfile.write("#define CTRL_DEFAULT                    0b{word:0{bits}b}\n\n".format(word=control.c_word, bits=CWORD_WIDTH_BITS))


def write_mux(hfile: TextIO, name: str, mux: Mux) -> None:

    mask = 0
    for bit in mux.pins:
        mask |= 1 << bit

    name = name.replace("Mux", "").upper()
    define = "#define MUX_{}_MASK".format(name)
    hfile.write("{define:40}0b{mask:0{bits}b}\n".format(define=define, mask=mask, bits=CWORD_WIDTH_BITS))

    for pname, pin in all_pins():
        if isinstance(pin, MuxPin):
            if pin.mux == mux:
                pname = pname.replace(".", "_").upper()
                control.reset()
                pin.enable()

                define = "#define MPIN_{}_BITS".format(pname)
                hfile.write("{define:40}0b{word:0{bits}b}\n".format(define=define, word=control.c_word & mask, bits=CWORD_WIDTH_BITS))
    hfile.write("\n")


def write_simple_pins(hfile: TextIO) -> None:
    for name, pin in all_pins():
        if isinstance(pin, Pin):
            name = name.replace(".", "_").upper()
            val = 1 << pin.num

            prefix = "L" if pin.level == Level.LOW else "H"

            define = "#define {}PIN_{}_BIT".format(prefix, name)
            hfile.write("{define:40}0b{val:0{bits}b}\n".format(define=define, val=val, bits=CWORD_WIDTH_BITS))



def generate_defines(hfile: TextIO) -> None:
    write_header(hfile)
    write_opcodes(hfile)

    hfile.write("/* Fetch */\n")
    hfile.write("#define NUM_FETCH_STEPS        {}\n\n".format(len(fetch)))

    hfile.write("/* Device setup */\n")
    write_default_cword(hfile)

    for name, mux in all_muxes():
        write_mux(hfile, name, mux)

    write_simple_pins(hfile)

    hfile.write("\n")

    write_footer(hfile)


if __name__ == "__main__":
    with open("../../include/microcode.c", "wt") as cfile:
        generate_microcode(cfile)
    with open("../../include/op-defs.h", "wt") as hfile:
        generate_defines(hfile)
