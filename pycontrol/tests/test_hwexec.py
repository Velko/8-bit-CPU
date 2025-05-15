#!/usr/bin/python3

import pytest
from libcpu.DeviceSetup import hardware

pytestmark = pytest.mark.hardware

A = hardware.gp_reg("A")
PC = hardware.PC

from libcpu.cpu_helper import CPUHelper
from libcpu.opcodes import opcode_of

@pytest.mark.hardware
def test_ldi_on_hw(cpu_helper: CPUHelper) -> None:

    # prepare binary of:
    #   ldi A, 123
    ldi_test_prog = bytes([opcode_of("ldi_A_imm"),
                           123])

    # reset A, to see if changed
    cpu_helper.load_reg8(A, 0)

    # run program on hardware
    cpu_helper.run_snippet(0x32, ldi_test_prog)

    # assert
    val = cpu_helper.read_reg8(A)
    assert val == 123

@pytest.mark.hardware
def test_rjmp_on_hw(cpu_helper: CPUHelper) -> None:

    # prepary binary of:
    #   rjmp next
    #   hlt       ; hlt is unexpected exit from snippet
    # next:
    #   brk       ; appended by run_snippet
    rjmp_test_prog = bytes([opcode_of("rjmp_imm"), 2,
                            opcode_of("hlt")])

    cpu_helper.run_snippet(0x8, rjmp_test_prog)

    val = cpu_helper.read_reg16(PC)

    # should point to next instruction after brk
    assert val == 0x0C
