#!/usr/bin/python3

import re, os.path
from typing import Dict, List, Optional, Sequence

class AddrMapItem:
    def __init__(self, addr: int, filename: str, lineno: int) -> None:
        self.addr = addr
        self.filename = filename
        self.lineno = lineno

    def __repr__(self):
        return f'0x{self.addr:04x} | {self.filename} | {self.lineno}'

class AddrMap:
    def __init__(self, filename: str) -> None:

        rx = re.compile("^.*?\|\s*([0-9A-Fa-f]+)\s*\|\s*(.*?):(\d+)")

        fnnoxt = os.path.splitext(filename)[0]

        self.by_addr: Dict[str, AddrMapItem] = dict()
        self.all_files = [filename]

        with open(f"bin/{fnnoxt}.lst") as f:
            for line in f:
                m = rx.match(line)
                if m:
                    # in the customasm addrspan output mode, line numbers are 0-based, add 1
                    item = AddrMapItem(int(m.group(1), base=16), m.group(2), int(m.group(3), base=10) + 1)

                    # we are generally interested in "latest" address for line, so replacing the
                    # dictionary element works for us fine
                    self.by_addr[item.addr] = item

                    if item.filename not in self.all_files:
                        self.all_files.append(item.filename)

        self.by_file_line = dict(map(lambda k: (f'{k.filename}:{k.lineno:06d}', k), self.by_addr.values()))

    def lookup_by_line(self, filename: str, lineno: int) -> Optional[AddrMapItem]:
        key = f'{filename}:{lineno:06d}'

        if key in self.by_file_line:
            return self.by_file_line[key]
        else:
            return None

    def lookup_by_addr(self, addr: int) -> Optional[AddrMapItem]:
        if addr in self.by_addr:
            return self.by_addr[addr]
        else:
            return None

    def files(self) -> Sequence[str]:
        return self.all_files
