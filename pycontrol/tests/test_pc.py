#!/usr/bin/python3

import pytest # type: ignore

pytestmark = pytest.mark.hardware

from libcpu.DeviceSetup import PC
from libcpu.cpu_exec import CPUBackendControl

def load_pc(backend: CPUBackendControl, value: int) -> None:
    backend.control.reset()
    backend.client.bus_set(value)
    PC.load.enable()
    backend.client.ctrl_commit(backend.control.c_word)
    backend.client.clock_tick()

    backend.control.reset()
    backend.client.off(backend.control.default)

def read_pc(backend: CPUBackendControl) -> int:
    backend.control.reset()
    PC.out.enable()
    backend.client.ctrl_commit(backend.control.c_word)
    value = backend.client.bus_get()

    backend.control.reset()
    backend.client.off(backend.control.default)

    return value


@pytest.mark.parametrize("expected", [255, 1, 2, 4, 8, 16, 32, 64, 128, 0])
def test_pc_load(cpu_backend_real: CPUBackendControl, expected: int) -> None:

    backend = cpu_backend_real

    load_pc(backend, expected)
    value = read_pc(backend)

    assert value == expected



class PCNext8: pass

# assuming that PC works at all (test_pc_load should prove that), there's no need
# to count full range. Since it is built from two 161 counter chips, we will select
# range that includes both of them. For example 8..40
@pytest.fixture(scope="module")
def set_pc_next8(cpu_backend_real: CPUBackendControl) -> PCNext8:
    # set PC to value so that next becomes 0
    # (easier to test this way)
    load_pc(cpu_backend_real, 7)

    return PCNext8()


@pytest.mark.parametrize("expected", range(8, 40))
def test_pc_count(cpu_backend_real: CPUBackendControl, set_pc_next8: PCNext8, expected: int) -> None:
    backend = cpu_backend_real

    PC.count.enable()
    backend.client.ctrl_commit(backend.control.c_word)
    backend.client.clock_tick()

    value = read_pc(cpu_backend_real)

    assert value == expected
