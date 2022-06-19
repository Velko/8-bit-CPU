import pytest

from libcpu.cpu import *
from libcpu.test_helpers import CPUHelper
from libcpu.DeviceSetup import IOCtl


def test_outa_emu(cpu_helper: CPUHelper) -> None:
    IOCtl.reset_port()
    cpu_helper.load_reg8(A, 120)

    out(4, A)

    assert IOCtl.saved_value == 120

@pytest.mark.hardware
def test_outb_int_hw(cpu_helper: CPUHelper) -> None:

    cpu_helper.load_reg8(B, 110)

    # prepare binary of:
    #   out 0, B
    out_test_prog = bytes([opcode_of("out_imm_B"), 0])

    # run program on hardware
    val = cpu_helper.run_snippet(14, out_test_prog)

    # assert
    assert val == '110\n'

@pytest.mark.hardware
def test_outc_char_hw(cpu_helper: CPUHelper) -> None:

    cpu_helper.load_reg8(C, 102)

    # prepare binary of:
    #   out 4, C
    out_test_prog = bytes([opcode_of("out_imm_C"), 4])

    # run program on hardware
    val = cpu_helper.run_snippet(33, out_test_prog)

    # assert
    assert val == 'f'