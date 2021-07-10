#!/usr/bin/python3

import pytest

pytestmark = pytest.mark.hardware

from libcpu.test_helpers import CPUHelper
from libcpu.cpu import *

@pytest.mark.hardware
def test_ldi_on_hw(cpu_helper: CPUHelper) -> None:

    # prepare binary of:
    #   ldi A, 123
    ldi_test_prog = bytes([opcode_of("ldi_A_imm"),
                           123])

    # reset A, to see if changed
    cpu_helper.load_reg8(A, 0)

    # run program on hardware
    cpu_helper.run_snippet(32, ldi_test_prog)

    # assert
    val = cpu_helper.read_reg8(A)
    assert val == 123