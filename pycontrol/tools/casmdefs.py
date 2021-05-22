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

    for microcode in opcodes.values():


        in_args = []
        glue_args = ["0x{:02x}".format(microcode.opcode)]
        for i, arg in enumerate(microcode.args):
            if isinstance(arg, Register):
                in_args.append(str(arg))
            elif isinstance(arg, OpcodeArg):
                if arg == OpcodeArg.BYTE:
                    in_args.append(f"{{value{i}}}")
                    glue_args.append(f"value{i}`8")
                elif arg == OpcodeArg.ADDR:
                    in_args.append(f"{{address{i}}}")
                    glue_args.append(f"address{i}[15:8]")
                    glue_args.append(f"address{i}[7:0]")
                else:
                    raise TypeError
            else:
                print (microcode.name, arg)
                raise TypeError

        iargs = ", ".join(in_args)
        gargs = " @ ".join(glue_args)

        rdfile.write(f"    {microcode.name}  ({iargs}) => {gargs}\n")


        #define OP_{:20}0x{:02x}\n".format(name, microcode.opcode))


    rdfile.write("}\n")


if __name__ == "__main__":
    with open("export-c/velkocpu.def", "wt") as rdfile:
        generate_casmdefs(rdfile)