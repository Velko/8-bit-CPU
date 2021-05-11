#!/usr/bin/python3

import pytest
import random

from libcpu.cpu import *
from libcpu.markers import Addr
from libcpu.cpu_exec import CPUBackendControl
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
def fill_ram(random_bytes: Sequence[int], cpu_backend_real: CPUBackendControl) -> FillRam:
    for addr in random_addr:
        ldi (A, random_bytes[addr])
        st (Addr(addr), A)

    return FillRam()


@pytest.mark.parametrize("addr", random_addr)
def test_store_load(cpu_backend_real: CPUBackendControl, random_bytes: Sequence[int], fill_ram: FillRam, addr: int) -> None:

    ld (A, Addr(addr))
    actual = peek(A)

    assert random_bytes[addr] == actual
