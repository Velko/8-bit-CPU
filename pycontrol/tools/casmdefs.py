#!/usr/bin/env python3

import localpath

from libcpu.devices import Register
from libcpu.opcode_builder import OpcodeArg
from libcpu.opcodes import opcodes

from typing import TextIO



def generate_casmdefs(rdfile: TextIO) -> None:
    rdfile.write("#bits 8\n")
    rdfile.write("#ruledef\n")
    rdfile.write("{\n")

    xprefix = opcodes["xprefix"]

    for microcode in opcodes.values():

        # xprefix is not an instruction, skip it
        if microcode == xprefix: continue

        in_args = []
        glue_args = []

        # insert xprefix if opcode > 255, CPU will fetch
        # next byte for remainder
        opcode = microcode.opcode
        while opcode > 0xFF:
            glue_args.append(f"0x{xprefix.opcode:02x}")
            opcode -= 0x100

        glue_args.append(f"0x{opcode:02x}")

        for i, arg in enumerate(microcode.args):
            if isinstance(arg, Register):
                in_args.append(str(arg))
            elif isinstance(arg, OpcodeArg):
                if arg == OpcodeArg.BYTE:
                    in_args.append(f"{{value{i}}}")
                    glue_args.append(f"value{i}`8")
                elif arg == OpcodeArg.ADDR:
                    in_args.append(f"{{address{i}}}")
                    glue_args.append(f"address{i}[7:0]")
                    glue_args.append(f"address{i}[15:8]")
                else:
                    raise TypeError
            else:
                print (microcode.name, arg)
                raise TypeError

        iargs = ", ".join(in_args)
        gargs = " @ ".join(glue_args)

        rdfile.write(f"    {microcode.name}  {iargs} => {gargs}\n")


        #define OP_{:20}0x{:02x}\n".format(name, microcode.opcode))


    rdfile.write("}\n")
    rdfile.write("#include \"aliases.def\"\n")


if __name__ == "__main__":
    with open("../../include/velkocpu.def", "wt") as rdfile:
        generate_casmdefs(rdfile)