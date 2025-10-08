#!/usr/bin/python3

import pytest


from libcpu.opcodes import opcodes
from libcpu.DeviceSetup import hardware as hw
from libcpu.devices import Flags
from libcpu.opcode_builder import MicrocodeBuilder
from libcpu.pin import MuxPin
from libcpu.pseudo_devices import EnableCallback
from libcpu.ctrl_word import CtrlWord

from collections.abc import Iterator, Sequence

from libcpu.util import ControlSignal

def calc_flags_alt_PC_counts() -> Iterator[tuple[str, int, int, str, str]]:

    # all opcodes, that are flags-dependent
    for name, microcode in filter(lambda opc: opc[1].is_flag_dependent(), opcodes.items()):

        # count PC increments in default path
        default_len = sum(1 for s in microcode._steps if hw.PC.out in s)

        # and compare it to flags-alternative
        for f_alt in microcode.f_alt:

            # skip those where PC is loaded with new value
            if hw.PC.load in f_alt.steps[-1]:
                continue

            # count PC increments in flags-alt steps
            alt_len = sum(1 for s in f_alt.steps if hw.PC.out in s)

            yield name, default_len, alt_len, str(f_alt.mask), str(f_alt.value)


@pytest.mark.parametrize("_name,default_len,alt_len,_mask,_val",  calc_flags_alt_PC_counts())
def test_opcode_pc_len_equal_in_flags_alt(_name: str, default_len: int, alt_len: int, _mask: str, _val: str) -> None:
    assert default_len == alt_len

class DummySignal(ControlSignal):
    def __init__(self) -> None:
        ControlSignal.__init__(self)

    def apply_enable(self, c_word: int) -> int:
        raise Exception("Should not reach")

class OpcodeFixture:
    def __init__(self) -> None:
        builder = MicrocodeBuilder()

        self.orig_default = DummySignal()
        self.orig_alt = DummySignal()
        self.control = CtrlWord()
        self.default_taken = False
        self.alt_taken = False

        builder.add_instruction("dummy")\
            .add_step(EnableCallback(self.log_default, self.orig_default))\
            .add_condition(mask=Flags.C, value=Flags.C)\
                .add_step(EnableCallback(self.log_alt, self.orig_alt))

        self.opcodes, self.ops_by_code = builder.build()

    def log_default(self, c_word: int) -> int:
        self.default_taken = True
        return c_word

    def log_alt(self, c_word: int) -> int:
        self.alt_taken = True
        return c_word

    def reset(self) -> None:
        self.default_taken = False
        self.alt_taken = False




@pytest.fixture
def fake_opcodes() -> OpcodeFixture:
    return OpcodeFixture()

def test_opcode_flag_taken(fake_opcodes: OpcodeFixture) -> None:

    op = fake_opcodes.opcodes["dummy"]

    fake_opcodes.reset()

    for s_idx in range(8):
        c, is_last = op.get_step(s_idx, Flags.C)

        for e in c:
            fake_opcodes.control.enable(e)

        if is_last:
            break

    assert fake_opcodes.alt_taken == True
    assert fake_opcodes.default_taken == False

def test_opcode_flag_default(fake_opcodes: OpcodeFixture) -> None:

    op = fake_opcodes.opcodes["dummy"]

    fake_opcodes.reset()

    for s_idx in range(8):
        c, is_last = op.get_step(s_idx, Flags.Empty)

        for e in c:
            fake_opcodes.control.enable(e)

        if is_last:
            break

    assert fake_opcodes.alt_taken == False
    assert fake_opcodes.default_taken == True



def all_steps() -> Iterator[tuple[str, str, int, Sequence[ControlSignal]]]:
    for name, op in opcodes.items():
        for steps in op._steps:
            yield name, "default", 0, steps

@pytest.mark.parametrize("_name,_flags,_vfal,step", all_steps())
def test_mux_enables(_name: str, _flags: str, _vfal: int, step: Sequence[ControlSignal]) -> None:
#    instr = opcodes["ld_A_addr"]
#    steps = instr._steps[3]

    muxes_found = []
    sig_cache = []

    for signal in step:
        if isinstance(signal, EnableCallback):
            signal = signal.original

        if isinstance(signal, MuxPin):
            if signal not in sig_cache: # aliased pins (PC.out == PC.inc)
                assert signal.mux not in muxes_found
                muxes_found.append(signal.mux)
                sig_cache.append(signal)
