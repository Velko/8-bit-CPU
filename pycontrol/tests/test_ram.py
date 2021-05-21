#!/usr/bin/python3

import pytest
import random

from libcpu.cpu import *
from libcpu.markers import Addr
from libcpu.test_helpers import CPUHelper
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
def fill_ram(random_bytes: Sequence[int], cpu_helper: CPUHelper) -> FillRam:
    for addr in random_addr:
        cpu_helper.write_ram(addr, random_bytes[addr])

    return FillRam()


@pytest.mark.parametrize("addr", random_addr)
def test_store_load(cpu_helper: CPUHelper, random_bytes: Sequence[int], fill_ram: FillRam, addr: int) -> None:

    ld (A, Addr(addr))
    actual = cpu_helper.read_reg8(A)

    assert random_bytes[addr] == actual
