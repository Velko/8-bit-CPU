#!/usr/bin/python3

import pytest # type: ignore
import random

from libcpu.cpu import *
from libcpu.cpu_exec import CPUBackendControl
from typing import Sequence

pytestmark = pytest.mark.hardware

# can not make as a fixture, because it can not be
# unpacked for parametrization (couldn't find a way)
def make_random_addr() -> Sequence[int]:

    # make sure addresses are unique
    addr = list(range(256))
    random.shuffle(addr)

    # 32 addresses out of 256 should be enough to
    # verify that RAM works as expected
    return addr[:32]

random_addr = make_random_addr()


class FillRam: pass

@pytest.fixture(scope="module")
def fill_ram(random_bytes, cpu_backend_real: CPUBackendControl) -> FillRam:
    for addr in random_addr:
        ldi (A, random_bytes[addr])
        st (addr, A)

    return FillRam()


@pytest.mark.parametrize("addr", random_addr)
def test_store_load(cpu_backend_real: CPUBackendControl, random_bytes: Sequence[int], fill_ram: FillRam, addr: int):

    ld (A, addr)
    actual = peek(A)

    assert random_bytes[addr] == actual
