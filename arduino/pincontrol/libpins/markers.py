#!/usr/bin/python3


next_addr = 0

def org(address):
    global next_addr
    next_addr = address

def rewind(offset):
    global next_addr
    next_addr -= offset

def align(alignment):
    global next_addr

    mod = next_addr % alignment
    if mod != 0:
        next_addr += alignment - mod

class Bytes:
    def __init__(self, size):
        global next_addr

        self.start = next_addr
        self.size = size
        next_addr += size

class Byte(Bytes):
    def __init__(self):
        Bytes.__init__(self, 1)

class Label:
    def __init__(self):
        self.addr = None

    def here(self):
        self.addr = next_addr
