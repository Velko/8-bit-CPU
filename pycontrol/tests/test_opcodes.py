#!/usr/bin/python3

import pytest


from libcpu.opcodes import opcodes
from libcpu.devmap import PC
from libcpu.devices import Flags
from libcpu.opcode_builder import MicrocodeBuilder
from libcpu.pin import ControlSignal, MuxPin
from libcpu.pseudo_devices import ProxyPin
from libcpu.ctrl_word import CtrlWord

from collections.abc import Iterator, Sequence

def calc_flags_alt_PC_counts() -> Iterator[tuple[str, int, int, str, str]]:

    # all opcodes, that are flags-dependent
    for name, microcode in filter(lambda opc: opc[1].is_flag_dependent(), opcodes.items()):

        # count PC increments in default path
        default_len = sum(1 for s in microcode._steps if PC.out in s)

        # and compare it to flags-alternative
        for f_alt in microcode.f_alt:

            # skip those where PC is loaded with new value
            if PC.load in f_alt.steps[-1]:
                continue

            # count PC increments in flags-alt steps
            alt_len = sum(1 for s in f_alt.steps if PC.out in s)

            yield name, default_len, alt_len, str(f_alt.mask), str(f_alt.value)


@pytest.mark.parametrize("_name,default_len,alt_len,_mask,_val",  calc_flags_alt_PC_counts())
def test_opcode_pc_len_equal_in_flags_alt(_name: str, default_len: int, alt_len: int, _mask: str, _val: str) -> None:
    assert default_len == alt_len

class DummySignal(ControlSignal):
    def __init__(self) -> None:
        ControlSignal.__init__(self)
        self.enabled = False

    def apply_enable(self, c_word: int) -> int:
        self.enabled = True
        return c_word

class OpcodeFixture:
    def __init__(self) -> None:
        builder = MicrocodeBuilder()

        self.default_path = DummySignal()
        self.alt_path = DummySignal()
        self.control = CtrlWord()

        builder.add_instruction("dummy")\
            .add_step(self.default_path)\
            .add_condition(mask=Flags.C, value=Flags.C)\
                .add_step(self.alt_path)

        self.opcodes, self.ops_by_code = builder.build()



@pytest.fixture
def fake_opcodes() -> OpcodeFixture:
    return OpcodeFixture()

def test_opcode_flag_taken(fake_opcodes: OpcodeFixture) -> None:

    op = fake_opcodes.opcodes["dummy"]

    for s_idx in range(8):
        c, is_last = op.get_step(s_idx, Flags.C)

        for e in c:
            fake_opcodes.control.enable(e)

        if is_last:
            break

    assert fake_opcodes.alt_path.enabled == True
    assert fake_opcodes.default_path.enabled == False

def test_opcode_flag_default(fake_opcodes: OpcodeFixture) -> None:

    op = fake_opcodes.opcodes["dummy"]

    for s_idx in range(8):
        c, is_last = op.get_step(s_idx, Flags.Empty)

        for e in c:
            fake_opcodes.control.enable(e)

        if is_last:
            break

    assert fake_opcodes.alt_path.enabled == False
    assert fake_opcodes.default_path.enabled == True



def all_steps() -> Iterator[tuple[str, str, int, Sequence[ControlSignal]]]:
    for name, op in opcodes.items():
        for steps in op._steps:
            yield name, "default", 0, steps

@pytest.mark.parametrize("_name,_flags,_vfal,step", all_steps())
def test_mux_enables(_name: str, _flags: str, _vfal: int, step: Sequence[ControlSignal]) -> None:

    muxes_found = []
    sig_cache = []

    for signal in step:
        if isinstance(signal, ProxyPin):
            signal = signal.original

        if isinstance(signal, MuxPin):
            if signal not in sig_cache: # aliased pins (PC.out == PC.inc)
                assert signal.mux not in muxes_found
                muxes_found.append(signal.mux)
                sig_cache.append(signal)
