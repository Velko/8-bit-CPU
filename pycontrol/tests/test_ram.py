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

    assert fill_ram.contents[addr] == cpu_helper.regs.A

def test_ldx_hw(cpu_helper: CPUHelper) -> None:

    cpu_helper.ram[0x2203] = 0x33
    cpu_helper.regs.B = 3

    # prepare binary of:
    #   ldx A, 0x2200, B
    out_test_prog = bytes([
        opcode_of("ldx_A_addr_B"), 0x00, 0x22,
        ])

    cpu_helper.run_snippet(0x0, out_test_prog)

    assert cpu_helper.regs.A == 0x33

@pytest.mark.parametrize("addr", random_addr)
def test_load_sdp(cpu_helper: CPUHelper, acpu: AssistedCPU, fill_ram: FillRam, addr: int) -> None:

    cpu_helper.regs.SDP = addr

    acpu.lpi (A, SDP)

    assert fill_ram.contents[addr] == cpu_helper.regs.A
    assert addr + 1 == cpu_helper.regs.SDP
