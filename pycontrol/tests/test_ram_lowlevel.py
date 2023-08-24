#!/usr/bin/python3

import pytest

pytestmark = pytest.mark.hardware

from libcpu.cpu_helper import CPUHelper
from libcpu.pinclient import PinClient
from typing import Iterator, Sequence

def singlebit_addresses() -> Iterator[int]:
    yield 0
    for b in range(16):
        yield 1 << b

class FillRam: pass

@pytest.fixture(scope="module")
def fill_ram(random_bytes: Sequence[int], pins_client_real: PinClient) -> FillRam:
    cpu_helper = CPUHelper(pins_client_real)

    for addr in singlebit_addresses():
        cpu_helper.write_ram(addr, random_bytes[addr])

    return FillRam()


@pytest.mark.parametrize("addr", singlebit_addresses())
def test_load_singlebit_addr(cpu_helper: CPUHelper, random_bytes: Sequence[int], fill_ram: FillRam, addr: int) -> None:

    actual = cpu_helper.read_ram(addr)

    assert random_bytes[addr] == actual

