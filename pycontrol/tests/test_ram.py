#!/usr/bin/python3

import pytest

from libcpu.cpu import *

def test_store_load(cpu_backend_real):
    ldi (B, 42)
    ldi (A, 11)

    st (5, B)
    ld (A, 5)

    val = peek (A)

    assert val == 42
