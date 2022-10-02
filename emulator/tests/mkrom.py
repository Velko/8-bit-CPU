#!/usr/bin/python3

def gen_data():
    data = 3
    while True:
        data = (data + 7) & 0xFF
        yield data

for i, data in zip(range(128 * 1024), gen_data()):
    print (f"{data:02x} ", end="")
    if i & 0xF == 0xF:
        print()