#!/usr/bin/python3


next_addr = 0

def org(address):
    global next_addr
    next_addr = address

class Bytes:
    def __init__(self, size):
        global next_addr

        self.start = next_addr
        self.size = size
        next_addr += size

class Byte(Bytes):
    def __init__(self):
        Bytes.__init__(self, 1)
