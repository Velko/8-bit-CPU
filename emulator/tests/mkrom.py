#!/usr/bin/python3

data = 3
for i in range(128 * 1024):
    data = (data + 7) & 0xFF
    print (f"{data:02x} ", end="")

    if i & 0xF == 0xF:
        print()