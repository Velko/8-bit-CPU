#!/usr/bin/env python3

import localpath

from libcpu.opcodes import opcodes, fetch
from libcpu.devices import Flags

from libcpu.ctrl_word import CtrlWord

control = CtrlWord()


def generate_microcode(cfile):
    cfile.write ("#include \"microcode.h\"\n\n")

    words = process_steps(fetch._steps)
    cfile.write ("const uint16_t op_fetch = {{{}}};\n\n".format(", ".join(words)))

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


if __name__ == "__main__":
    with open("export-c/microcode.c", "wt") as cfile:
        generate_microcode(cfile)
