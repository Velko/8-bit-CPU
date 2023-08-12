import pytest

from libcpu.cpu import *
from libcpu.test_helpers import CPUHelper
from libcpu.pseudo_devices import IOMon

from typing import Iterator, Tuple

def test_outa_emu(cpu_helper: CPUHelper) -> None:
    IOMon.reset_port()
    cpu_helper.load_reg8(A, 120)

    out(4, A)

    assert IOMon.saved_value == 120

def outb_args() -> Iterator[Tuple[str, int, int, str]]:
    yield "unsigned small", 0, 110, " 110\n"
    yield "unsigned large", 0, 245, " 245\n"
    yield "signed positive", 1, 40, "  40\n"
    yield "signed negative", 1, 140, "-116\n"
    yield "hex", 2, 233, "h e9\n"
    yield "oct", 3, 89, "o131\n"

@pytest.mark.emulator
@pytest.mark.parametrize("desc,mode,val,expected", outb_args())
def test_outb_int_hw(cpu_helper: CPUHelper, desc: str, mode: int, val: int, expected: str) -> None:

    cpu_helper.load_reg8(D, mode);

    cpu_helper.load_reg8(B, val)

    # prepare binary of:
    #   out 1, D
    #   out 0, B
    out_test_prog = bytes([
        opcode_of("out_imm_D"), 1,
        opcode_of("out_imm_B"), 0
        ])

    # run program on hardware
    res = cpu_helper.run_snippet(14, out_test_prog)

    # assert
    assert res == expected

@pytest.mark.emulator
def test_outc_char_hw(cpu_helper: CPUHelper) -> None:

    cpu_helper.load_reg8(C, 102)

    # prepare binary of:
    #   out 4, C
    out_test_prog = bytes([opcode_of("out_imm_C"), 4])

    # run program on hardware
    val = cpu_helper.run_snippet(33, out_test_prog)

    # assert
    assert val == 'f'

@pytest.mark.emulator
def test_outc_newline_hw(cpu_helper: CPUHelper) -> None:

    cpu_helper.load_reg8(C, 10)

    # prepare binary of:
    #   out 4, C
    out_test_prog = bytes([opcode_of("out_imm_C"), 4])

    # run program on hardware
    val = cpu_helper.run_snippet(33, out_test_prog)

    # assert
    assert val == '\n'
