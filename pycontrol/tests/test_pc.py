#!/usr/bin/python3

import pytest

pytestmark = pytest.mark.hardware

from libcpu.cpu import *

def load_pc(backend, value):
    backend.client.bus_set(value)
    PC.load.enable()
    backend.client.ctrl_commit(backend.control.c_word)
    backend.client.clock_tick()

    backend.control.reset()
    backend.client.off(backend.control.default)

def read_pc(backend):
    PC.out.enable()
    backend.client.ctrl_commit(backend.control.c_word)
    value = backend.client.bus_get()

    backend.control.reset()
    backend.client.off(backend.control.default)

    return value


@pytest.mark.parametrize("expected", [255, 1, 2, 4, 8, 16, 32, 64, 128, 0])
def test_pc_load(cpu_backend_real, expected):

    backend = cpu_backend_real

    load_pc(backend, expected)
    value = read_pc(backend)

    assert value == expected



# assuming that PC works at all (test_pc_load should prove that), there's no need
# to count full range. Since it is built from two 161 counter chips, we will select
# range that includes both of them. For example 8..40
@pytest.fixture(scope="module")
def set_pc_next8(cpu_backend_real):
    # set PC to value so that next becomes 0
    # (easier to test this way)
    load_pc(cpu_backend_real, 7)


@pytest.mark.parametrize("expected", range(8, 40))
def test_pc_count(cpu_backend_real, set_pc_next8, expected):
    backend = cpu_backend_real

    PC.count.enable()
    backend.client.ctrl_commit(backend.control.c_word)
    backend.client.clock_tick()

    value = read_pc(cpu_backend_real)

    assert value == expected
