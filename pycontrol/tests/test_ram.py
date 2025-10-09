#!/usr/bin/python3

import pytest
import random

from libcpu.opcodes import opcode_of
from libcpu.pinclient import PinClient
from libcpu.assisted_cpu import AssistedCPU
from libcpu.devmap import A, B, SDP
from libcpu.markers import Addr
from libcpu.cpu_helper import CPUHelper
from collections.abc import Sequence

from conftest import FillRam

pytestmark = pytest.mark.hardware

# can not make as a fixture, because it can not be
# unpacked for parametrization (couldn't find a way)
def make_random_addr() -> Sequence[int]:

    # make sure addresses are unique, skip ROM area
    addr = list(range(0xE000))
    random.shuffle(addr)

    # 64 addresses out of 65536 should be enough to
    # verify that RAM works as expected
    return addr[:64]

random_addr = make_random_addr()


@pytest.fixture(scope="module")
def fill_ram(pins_client_real: PinClient) -> FillRam:
    ram = FillRam(random_addr)
    ram.write_ram(pins_client_real)

    return ram


@pytest.mark.parametrize("addr", random_addr)
def test_store_load(cpu_helper: CPUHelper, acpu: AssistedCPU, fill_ram: FillRam, addr: int) -> None:

    acpu.ld (A, Addr(addr))
    actual = cpu_helper.read_reg8(A)

    assert fill_ram.contents[addr] == actual

def test_ldx_hw(cpu_helper: CPUHelper) -> None:

    cpu_helper.write_ram(0x2203, 0x33)
    cpu_helper.load_reg8(B, 3)

    # prepare binary of:
    #   ldx A, 0x2200, B
    out_test_prog = bytes([
        opcode_of("ldx_A_addr_B"), 0x00, 0x22,
        ])

    cpu_helper.run_snippet(0x0, out_test_prog)

    val = cpu_helper.read_reg8(A)

    assert val == 0x33

@pytest.mark.parametrize("addr", random_addr)
def test_load_sdp(cpu_helper: CPUHelper, acpu: AssistedCPU, fill_ram: FillRam, addr: int) -> None:

    cpu_helper.load_reg16(SDP, addr)

    acpu.lpi (A, SDP)

    actual = cpu_helper.read_reg8(A)
    new_addr = cpu_helper.read_reg16(SDP)

    assert fill_ram.contents[addr] == actual
    assert addr + 1 == new_addr
