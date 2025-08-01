#!/usr/bin/python3

import pytest

pytestmark = pytest.mark.hardware

from libcpu.cpu_helper import CPUHelper
from libcpu.assisted_cpu import AssistedCPU
from libcpu.DeviceSetup import hardware
from libcpu.opcodes import opcode_of

A = hardware.gp_reg("A")

def test_dummy_local(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:

    cpu_helper.load_reg8(A, 0)

    acpu.dummy_ext(45)

    val = cpu_helper.read_reg8(A)

    assert val == 45

# Dummyext is a copy of ldi A, imm with few additional internal nops
# if it works fine, it will load opcode of HLT into A. The opcode index
# is approx. 0x10D, if ext bit fails, it will execute a 1 byte ADD instruction
# instead and then hit HLT as next instruction
fetch_test_prog = bytes([opcode_of("_xprefix"),
                         opcode_of("dummyext_imm") & 0xFF,
                         opcode_of("hlt")])

def test_dummy_fetch(acpu: AssistedCPU) -> None:
    cpu_helper = CPUHelper(acpu.client)

    # load program into ram
    cpu_helper.load_snippet(0x32, fetch_test_prog)

    # reset A, to see if changed
    cpu_helper.load_reg8(A, 0)

    # act
    acpu.fetch_and_execute()

    # assert
    val = cpu_helper.read_reg8(A)
    assert val == opcode_of("hlt")

#@pytest.mark.skip("Not supported by current emulator")
def test_dummy_fetch_on_hw(cpu_helper: CPUHelper) -> None:
    # reset A, to see if changed
    cpu_helper.load_reg8(A, 0)

    # run program on hardware
    cpu_helper.run_snippet(0x54, fetch_test_prog)

    # assert
    val = cpu_helper.read_reg8(A)
    assert val == opcode_of("hlt")
