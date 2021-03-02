#!/usr/bin/python3

import pytest # type: ignore

pytestmark = pytest.mark.hardware

from libcpu.DeviceSetup import Mar, Ram
from libcpu.cpu_exec import CPUBackendControl
from typing import Iterator, Sequence

def set_mar(backend: CPUBackendControl, value: int) -> None:
    backend.control.reset()
    Mar.load.enable()
    backend.client.bus_set(value)
    backend.client.ctrl_commit(backend.control.c_word)
    backend.client.clock_tick()

    backend.control.reset()
    backend.client.off(backend.control.default)

def write_ram(backend: CPUBackendControl, value: int) -> None:
    backend.control.reset()
    Ram.write.enable()
    backend.client.bus_set(value)

    backend.client.ctrl_commit(backend.control.c_word)

    # clocked RAM write
    backend.client.clock_tick()

    backend.control.reset()
    backend.client.off(backend.control.default)

def read_ram(backend: CPUBackendControl) -> int:
    backend.control.reset()
    Ram.out.enable()

    backend.client.ctrl_commit(backend.control.c_word)
    val = backend.client.bus_get()

    backend.control.reset()
    backend.client.off(backend.control.default)

    return val

def singlebit_addresses() -> Iterator[int]:
    yield 0
    for b in range(8):
        yield 1 << b

class FillRam: pass

@pytest.fixture(scope="module")
def fill_ram(random_bytes: Sequence[int], cpu_backend_real: CPUBackendControl) -> FillRam:
    for addr in singlebit_addresses():
        set_mar(cpu_backend_real, addr)
        write_ram(cpu_backend_real, random_bytes[addr])

    return FillRam()


@pytest.mark.parametrize("addr", singlebit_addresses())
def test_load_singlebit_addr(cpu_backend_real: CPUBackendControl, random_bytes: Sequence[int], fill_ram: FillRam, addr: int):

    set_mar(cpu_backend_real, addr)

    actual = read_ram(cpu_backend_real)

    assert random_bytes[addr] == actual

