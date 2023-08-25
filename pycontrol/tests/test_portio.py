import pytest

from libcpu.cpu import *
from libcpu.cpu_helper import CPUHelper
from libcpu.assisted_cpu import AssistedCPU
from libcpu.util import RunMessage

from typing import Iterator, Tuple

def test_outa_emu_char(cpu_helper: CPUHelper, cpu_backend_real: AssistedCPU) -> None:
    cpu_helper.load_reg8(A, 120)

    message = out(4, A)

    assert message is not None
    assert message.reason == RunMessage.Reason.OUT
    assert message.payload == 'x'

def ansi_red(text: str) -> str:
    return f"\x1b[1;31m{text}\x1b[0m\n"

def outb_args() -> Iterator[Tuple[str, int, int, str]]:
    yield "unsigned small", 0, 110, ansi_red(" 110")
    yield "unsigned large", 0, 245, ansi_red(" 245")
    yield "signed positive", 1, 40, ansi_red("  40")
    yield "signed negative", 1, 140, ansi_red("-116")
    yield "hex", 2, 233, ansi_red("h e9")
    yield "oct", 3, 89, ansi_red("o131")

@pytest.mark.parametrize("desc,mode,val,expected", outb_args())
def test_outa_emu_num(cpu_helper: CPUHelper, cpu_backend_real: AssistedCPU, desc: str, mode: int, val: int, expected: str) -> None:
    cpu_helper.load_reg8(B, mode)
    out(1, B)

    cpu_helper.load_reg8(A, val)
    message = out(0, A)

    assert message is not None
    assert message.reason == RunMessage.Reason.OUT
    assert message.payload == expected

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
