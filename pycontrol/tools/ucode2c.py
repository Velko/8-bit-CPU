#!/usr/bin/env python3

import localpath

from libcpu.opcodes import opcodes, fetch
from libcpu.devices import Flags
from libcpu.pin import Pin, MuxPin, Level
from libcpu.discovery import all_pins, all_muxes

from libcpu.ctrl_word import CtrlWord

control = CtrlWord()


def generate_microcode(cfile):
    cfile.write ("#include \"microcode.h\"\n\n")

    words = process_steps(fetch._steps)
    cfile.write ("const uint16_t op_fetch[] = {{{}}};\n\n".format(", ".join(words)))

    cfile.write ("const struct op_microcode microcode[] PROGMEM = {\n")


    for key, microcode in opcodes.items():

        words = process_steps(microcode._steps)
        cfile.write ("\n    /* {:10} */\n".format(key))
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

def process_steps(steps):
    for pins in steps:
        control.reset()
        for pin in pins:
            pin.enable()

        yield "0x{:04x}".format(control.c_word)

def write_header(hfile):
    hfile.write("#ifndef OP_DEFS_H\n")
    hfile.write("#define OP_DEFS_H\n\n")

def write_footer(hfile):
    hfile.write("#endif /* OP_DEFS_H */\n")

def write_opcodes(hfile):
    hfile.write("/* Opcodes */\n")
    for key, microcode in opcodes.items():
        name = key.upper()

        hfile.write("#define OP_{:20}0x{:02x}\n".format(name, microcode.opcode))

    hfile.write("\n")

def write_default_cword(hfile):
    control.reset()

    hfile.write("#define CTRL_DEFAULT                    0b{:016b}\n\n".format(control.c_word))


def write_mux(hfile, name, mux):

    mask = 0
    for bit in mux.pins:
        mask |= 1 << bit

    name = name.replace("Mux", "").upper()
    define = "#define MUX_{}_MASK".format(name)
    hfile.write("{:40}0b{:016b}\n".format(define, mask))

    for pname, pin in all_pins():
        if isinstance(pin, MuxPin):
            if pin.mux == mux:
                pname = pname.replace(".", "_").upper()
                control.reset()
                pin.enable()

                define = "#define MPIN_{}_BITS".format(pname)
                hfile.write("{:40}0b{:016b}\n".format(define, control.c_word & mask))
    hfile.write("\n")


def write_simple_pins(hfile):
    for name, pin in all_pins():
        if isinstance(pin, Pin):
            name = name.replace(".", "_").upper()
            val = 1 << pin.num

            prefix = "L" if pin.level == Level.LOW else "H"

            define = "#define {}PIN_{}_BIT".format(prefix, name)
            hfile.write("{:40}0b{:016b}\n".format(define, val))



def generate_defines(hfile):
    write_header(hfile)
    write_opcodes(hfile)


    hfile.write("/* Device setup */\n")
    write_default_cword(hfile)

    for name, mux in all_muxes():
        write_mux(hfile, name, mux)

    write_simple_pins(hfile)

    hfile.write("\n")

    write_footer(hfile)


if __name__ == "__main__":
    with open("export-c/microcode.c", "wt") as cfile:
        generate_microcode(cfile)
    with open("export-c/op-defs.h", "wt") as hfile:
        generate_defines(hfile)
