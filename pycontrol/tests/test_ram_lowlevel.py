#!/usr/bin/python3

import pytest

pytestmark = pytest.mark.hardware

from libcpu.cpu import *

def set_mar(backend, value):

    Mar.load.enable()
    backend.client.bus_set(value)
    backend.client.ctrl_commit(backend.control.c_word)
    backend.client.clock_tick()

    backend.control.reset()
    backend.client.off(backend.control.default)

def write_ram(backend, value):
    Ram.write.enable()
    backend.client.bus_set(value)

    backend.client.ctrl_commit(backend.control.c_word)

    # clocked RAM write
    backend.client.clock_tick()

    backend.control.reset()
    backend.client.off(backend.control.default)

def read_ram(backend):
    Ram.out.enable()

    backend.client.ctrl_commit(backend.control.c_word)
    val = backend.client.bus_get()

    backend.control.reset()
    backend.client.off(backend.control.default)

    return val

def singlebit_addresses():
    yield 0
    for b in range(8):
        yield 1 << b

@pytest.fixture(scope="module")
def fill_ram(random_bytes, cpu_backend_real):
    for addr in singlebit_addresses():
        set_mar(cpu_backend_real, addr)
        write_ram(cpu_backend_real, random_bytes[addr])


@pytest.mark.parametrize("addr", singlebit_addresses())
def test_load_singlebit_addr(cpu_backend_real, random_bytes, fill_ram, addr):

    set_mar(cpu_backend_real, addr)

    actual = read_ram(cpu_backend_real)

    assert random_bytes[addr] == actual

