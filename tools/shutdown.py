#!/usr/bin/python3

from libcpu.pinclient import PinClient

if __name__ == "__main__":
    client = PinClient()
    client.shutdown()
