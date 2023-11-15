#!/usr/bin/python3

import pytest

from conftest import FillRam

pytestmark = pytest.mark.hardware

from libcpu.cpu_helper import CPUHelper
from libcpu.pinclient import PinClient

SINGLEBIT_ADDRESSES=[0x0000, 0x0001, 0x0002, 0x0004,
                     0x0008, 0x0010, 0x0020, 0x0040,
                     0x0080, 0x0100, 0x0200, 0x0400,
                     0x0800, 0x1000, 0x2000, 0x4000,
                     0x8000]

KNOWN_VALUES=[0x01, 0x55, 0x67, 0x95,
              0xc0, 0x05, 0x36, 0x7F,
              0xee, 0x8e, 0x67, 0x82,
              0x5e, 0x37, 0x33, 0x54,
              0xe2]

@pytest.fixture(scope="module")
def fill_ram(pins_client_real: PinClient) -> FillRam:
    ram = FillRam(SINGLEBIT_ADDRESSES, KNOWN_VALUES)
    ram.write_ram(pins_client_real)

    return ram


@pytest.mark.parametrize("addr", SINGLEBIT_ADDRESSES)
def test_load_singlebit_addr(cpu_helper: CPUHelper, fill_ram: FillRam, addr: int) -> None:

    actual = cpu_helper.read_ram(addr)

    assert fill_ram.contents[addr] == actual
