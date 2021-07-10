#!/usr/bin/python3

import pytest

pytestmark = pytest.mark.hardware

from libcpu.test_helpers import CPUHelper
from libcpu.cpu import *

def test_dummy_local(cpu_helper: CPUHelper) -> None:

    cpu_helper.load_reg8(A, 0)

    dummy_ext(45)

    val = cpu_helper.read_reg8(A)

    assert val == 45


fetch_test_prog = bytes([opcode_of("xprefix"),
                         opcode_of("dummyext_imm") & 0xFF,
                         123])

def test_dummy_fetch(cpu_helper: CPUHelper) -> None:

    # load program into ram
    cpu_helper.load_snippet(32, fetch_test_prog)

    # reset A, to see if changed
    cpu_helper.load_reg8(A, 0)

    # act
    cpu_helper.backend.fetch_and_execute()

    # assert
    val = cpu_helper.read_reg8(A)
    assert val == 123

#@pytest.mark.skip("Not supported by current emulator")
def test_dummy_fetch_on_hw(cpu_helper: CPUHelper) -> None:
    # reset A, to see if changed
    cpu_helper.load_reg8(A, 0)

    # run program on hardware
    cpu_helper.run_snippet(54, fetch_test_prog)

    # assert
    val = cpu_helper.read_reg8(A)
    assert val == 123