#!/usr/bin/python3

import pytest


from libcpu.opcodes import opcodes
from libcpu.DeviceSetup import PC
from libcpu.devices import Flags
from libcpu.opcode_builder import MicrocodeBuilder
from libcpu.pin import MuxPin
from libcpu.pseudo_devices import EnableCallback

from typing import Iterator, Tuple, List

from libcpu.util import ControlSignal

def calc_flags_alt_PC_counts() -> Iterator[Tuple[str, int, int, str, str]]:

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
def test_opcode_pc_len_equal_in_flags_alt(name: str, default_len: int, alt_len: int, mask: str, val: str) -> None:


        assert default_len == alt_len

class DummySignal(ControlSignal):
    def enable(self) -> None:
        raise Exception("Should not reach")

class OpcodeFixture:
    def __init__(self) -> None:
        builder = MicrocodeBuilder()

        self.orig_default = DummySignal()
        self.orig_alt = DummySignal()

        builder.add_instruction("dummy")\
            .add_step([EnableCallback(self.log_default, self.orig_default)])\
            .add_condition(mask=Flags.C, value=Flags.C)\
                .add_step([EnableCallback(self.log_alt, self.orig_alt)])

        self.opcodes = builder.build()

        self.reset()

    def log_default(self) -> None:
        self.default_taken = True

    def log_alt(self) -> None:
        self.alt_taken = True

    def reset(self) -> None:
        self.default_taken = False
        self.alt_taken = False




@pytest.fixture
def fake_opcodes() -> OpcodeFixture:
    return OpcodeFixture()

def test_opcode_flag_taken(fake_opcodes: OpcodeFixture) -> None:

    op = fake_opcodes.opcodes["dummy"]

    fake_opcodes.reset()

    steps = op.steps(lambda: 0b0100)

    for c in steps:
        for e in c:
            e.enable()

    assert fake_opcodes.alt_taken == True
    assert fake_opcodes.default_taken == False

def test_opcode_flag_default(fake_opcodes: OpcodeFixture) -> None:

    op = fake_opcodes.opcodes["dummy"]

    fake_opcodes.reset()

    steps = op.steps(lambda: 0)

    for c in steps:
        for e in c:
            e.enable()

    assert fake_opcodes.alt_taken == False
    assert fake_opcodes.default_taken == True



def all_steps() -> Iterator[Tuple[str, str, int, List[ControlSignal]]]:
    for name, op in opcodes.items():
        for steps in op._steps:
            yield name, "default", 0, steps

@pytest.mark.parametrize("name,flags,vfal,steps", all_steps())
def test_mux_enables(name: str, flags: str, vfal: int, steps: List[ControlSignal]) -> None:
#    instr = opcodes["ld_A_addr"]
#    steps = instr._steps[3]

    muxes_found = []

    for step in steps:
        if isinstance(step, MuxPin):
            assert step.mux not in muxes_found
            muxes_found.append(step.mux)
        if isinstance(step, EnableCallback):
            if isinstance(step.original, MuxPin):
                assert step.original.mux not in muxes_found
                muxes_found.append(step.original.mux)
