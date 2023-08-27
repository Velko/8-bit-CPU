#!/usr/bin/python3

import pytest

from conftest import FillRam

pytestmark = pytest.mark.hardware

from libcpu.cpu_helper import CPUHelper
from libcpu.pinclient import PinClient
from typing import Iterator, Sequence

def singlebit_addresses() -> Iterator[int]:
    yield 0
    for b in range(16):
        yield 1 << b

@pytest.fixture(scope="module")
def fill_ram(pins_client_real: PinClient) -> FillRam:
    ram = FillRam(list(singlebit_addresses()))
    ram.write_ram(pins_client_real)

    return ram


@pytest.mark.parametrize("addr", singlebit_addresses())
def test_load_singlebit_addr(cpu_helper: CPUHelper, fill_ram: FillRam, addr: int) -> None:

    actual = cpu_helper.read_ram(addr)

    assert fill_ram.contents[addr] == actual

