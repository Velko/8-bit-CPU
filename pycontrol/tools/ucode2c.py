#!/usr/bin/env python3

import localpath

from libcpu.opcodes import opcodes, fetch
from libcpu.devices import Flags

from libcpu.ctrl_word import CtrlWord

control = CtrlWord()


def generate_microcode():
    print ("#include \"opcode.h\"")
    print ()

    words = process_steps(fetch._steps)
    print ("uint16_t fetch = {{{}}};".format(", ".join(words)))
    print ()


    print ("struct opcode opcodes[] = {")


    for key, microcode in opcodes.items():

        words = process_steps(microcode._steps)
        print()
        print ("    /* {:10} */".format(key))
        print ("    {{ .default_steps = {{{}}},".format(", ".join(words)), end="")

        if not microcode.f_alt:
            print ("},")
            continue

        print ()
        print ("      .f_alt = {")

        for alt in microcode.f_alt:
            words = process_steps(alt.steps)
            print ("          /* mask: {} value: {} */".format(Flags.decode(alt.mask), Flags.decode(alt.value)))
            print ("          {{ .mask = 0x{:02x}, .value = 0x{:02x},".format(alt.mask, alt.value))
            print ("            .steps = {{{}}}, ".format(", ".join(words)))
            print ("          },")

            print ("      },")
        print ("    },")

    print ("};")

def process_steps(steps):
    for pins in steps:
        control.reset()
        for pin in pins:
            pin.enable()

        yield "0x{:04x}".format(control.c_word)


if __name__ == "__main__":
    generate_microcode()
