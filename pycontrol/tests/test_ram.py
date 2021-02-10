#!/usr/bin/python3

import pytest, random

from libcpu.cpu import *

pytestmark = pytest.mark.hardware

# can not make as a fixture, because it can not be
# unpacked for parametrization (couldn't find a way)
def make_random_addr():

    # make sure addresses are unique
    addr = list(range(256))
    random.shuffle(addr)

    # 32 addresses out of 256 should be enough to
    # verify that RAM works as expected
    return addr[:32]

random_addr = make_random_addr()


@pytest.fixture(scope="module")
def fill_ram(random_bytes, cpu_backend_real):
    for addr in random_addr:
        ldi (A, random_bytes[addr])
        st (addr, A)


@pytest.mark.parametrize("addr", random_addr)
def test_store_load(cpu_backend_real, random_bytes, fill_ram, addr):

    ld (A, addr)
    actual = peek(A)

    assert random_bytes[addr] == actual
