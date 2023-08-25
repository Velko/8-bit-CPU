#!/usr/bin/python3

import pytest
import random

from libcpu.opcodes import opcode_of
from libcpu.pinclient import PinClient
from libcpu.assisted_cpu import AssistedCPU, A, B
from libcpu.markers import Addr
from libcpu.cpu_helper import CPUHelper
from typing import Sequence

pytestmark = pytest.mark.hardware

# can not make as a fixture, because it can not be
# unpacked for parametrization (couldn't find a way)
def make_random_addr() -> Sequence[int]:

    # make sure addresses are unique
    addr = list(range(0x10000))
    random.shuffle(addr)

    # 64 addresses out of 65536 should be enough to
    # verify that RAM works as expected
    return addr[:64]

random_addr = make_random_addr()


class FillRam: pass

@pytest.fixture(scope="module")
def _fill_ram(random_bytes: Sequence[int], pins_client_real: PinClient) -> FillRam:
    cpu_helper = CPUHelper(pins_client_real)
    for addr in random_addr:
        cpu_helper.write_ram(addr, random_bytes[addr])

    return FillRam()


@pytest.mark.parametrize("addr", random_addr)
def test_store_load(cpu_helper: CPUHelper, acpu: AssistedCPU, random_bytes: Sequence[int], _fill_ram: FillRam, addr: int) -> None:

    acpu.ld (A, Addr(addr))
    actual = cpu_helper.read_reg8(A)

    assert random_bytes[addr] == actual

def test_ldx_hw(cpu_helper: CPUHelper) -> None:

    cpu_helper.write_ram(0x1203, 0x33)
    cpu_helper.load_reg8(B, 3)

    # prepare binary of:
    #   ldx A, 0x1200, B
    out_test_prog = bytes([
        opcode_of("ldx_A_addr_B"), 0x00, 0x12,
        ])

    cpu_helper.run_snippet(0x0, out_test_prog)

    val = cpu_helper.read_reg8(A)

    assert val == 0x33
