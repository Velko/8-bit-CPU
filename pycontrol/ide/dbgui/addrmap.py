#!/usr/bin/python3

import re, os.path
from typing import Dict, Iterable, Optional

class AddrMapItem:
    def __init__(self, addr: int, filename: str, lineno: int) -> None:
        self.addr = addr
        self.filename = filename
        self.lineno = lineno

    def __repr__(self) -> str:
        return f'0x{self.addr:04x} | {self.filename} | {self.lineno}'

class AddrMap:

    LST_LINE_RX = re.compile("^.*?\|\s*([0-9A-Fa-f]+)\s*\|\s*(.*?):(\d+)")

    def __init__(self, filename: str) -> None:

        self.main_file = filename
        self.dir = os.path.dirname(filename)

        self.reload()

    def reload(self) -> None:

        self.by_addr: Dict[int, AddrMapItem] = dict()
        self.all_files = [os.path.basename(self.main_file)]

        fnnoxt = os.path.splitext(self.main_file)[0]
        lstfile = f"{fnnoxt}.lst"

        if os.path.exists(lstfile):
            with open(lstfile) as f:
                for line in f:
                    m = AddrMap.LST_LINE_RX.match(line)
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

    def files(self) -> Iterable[str]:
        return map(lambda ad: os.path.join(self.dir, ad), self.all_files)
