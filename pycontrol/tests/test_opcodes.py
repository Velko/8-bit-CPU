#!/usr/bin/python3

import pytest


from libcpu.opcodes import opcodes
from libcpu.DeviceSetup import PC
from libcpu.devices import Flags

def calc_flags_alt_PC_counts():

    # all opcodes, that are flags-dependent
    for name, microcode in filter(lambda opc: opc[1].is_flag_dependent(), opcodes.items()):

        # count PC increments in default path
        default_len = sum(1 for s in microcode._steps if PC.count in s)

        # and compare it to flags-alternative
        for f_alt in microcode.f_alt:

            # skip those where PC is loaded with new value
            if PC.load in f_alt.steps[-1]: continue

            # count PC increments in flags-alt steps
            alt_len = sum(1 for s in f_alt.steps if PC.count in s)

            yield name, default_len, alt_len, Flags.decode(f_alt.mask), Flags.decode(f_alt.value)


@pytest.mark.parametrize("name,default_len,alt_len,mask,val",  calc_flags_alt_PC_counts())
def test_opcode_pc_len_equal_in_flags_alt(name, default_len, alt_len, mask,val):


        assert default_len == alt_len
