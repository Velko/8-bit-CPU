#!/usr/bin/python3

import pytest
from libcpu import cpu
from libcpu.DeviceSetup import PC, ProgMem
from libcpu.markers import InitializedBuffer
from libcpu.pseudo_devices import Imm

pytestmark = pytest.mark.hardware

from libcpu.test_helpers import CPUHelper
from libcpu.cpu import *

def test_dummy_local(cpu_helper: CPUHelper) -> None:

    cpu_helper.load_reg8(A, 0)

    dummy_ext(45)

    val = cpu_helper.read_reg8(A)

    assert val == 45

def test_dummy_fetch(cpu_helper: CPUHelper) -> None:

    # reset A, to see if changed
    cpu_helper.load_reg8(A, 0)

    # build a byte sequence
    xprefix = opcode_of("xprefix")
    dummy_ext = opcode_of("dummyext_imm")
    test_binary = bytes([xprefix, dummy_ext & 0xFF, 123])

    # load into CPU, point to it
    cpu_helper.write_bytes(32, test_binary)
    cpu_helper.load_reg16(PC, 32)

    # act
    cpu_helper.backend.fetch_and_execute()

    val = cpu_helper.read_reg8(A)
    assert val == 123
