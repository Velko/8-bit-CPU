from dataclasses import dataclass
import logging
import re

#; physical address : bit offset | logical address | file : line start : column start : line end : column end
#0:0 | e000 | bios.asm:20:0:20:8
#0:0 | e000 | bios.asm:21:4:21:12
HEADER_LINE = "; physical address : bit offset | logical address | file : line start : column start : line end : column end"
LINE_REGEX = r"[^|]*\|\s*([0-9a-fA-F]+)\s*\|\s*([^:]+):(\d+):(\d+):(\d+):(\d+)"

@dataclass
class AddressLineItem:
    logical_address: int
    file: str
    line_start: int
    column_start: int
    line_end: int
    column_end: int

    def __init__(self, line: str) -> None:
        match = re.match(LINE_REGEX, line)
        if not match:
            raise ValueError(f"Invalid address mapping line: {line}")

        self.logical_address = int(match.group(1), 16)
        self.file = match.group(2)
        self.line_start = int(match.group(3))
        self.column_start = int(match.group(4))
        self.line_end = int(match.group(5))
        self.column_end = int(match.group(6))

class AddressMapping:
    def __init__(self, file_paths: list[str]) -> None:
        self.by_file_line: dict[str, dict[int, AddressLineItem]] = {}
        self.by_logical_address: dict[int, AddressLineItem] = {}
        for file_path in file_paths:
            logging.getLogger().info(f"Processing address to source mapping file: {file_path}")
            with open(file_path, 'r') as f:
                header = f.readline().strip()
                if header != HEADER_LINE:
                    raise ValueError(f"Invalid header in address mapping file: {header}")

                for line in f:
                    line = line.strip()
                    if line:
                        try:
                            mapping = AddressLineItem(line)
                            if mapping.file not in self.by_file_line:
                                self.by_file_line[mapping.file] = {}
                            self.by_file_line[mapping.file][mapping.line_start] = mapping
                            self.by_logical_address[mapping.logical_address] = mapping
                        except ValueError as e:
                            logging.getLogger().warning(f"Warning: {e}")

    @property
    def unique_files(self) -> list[str]:
        return list(self.by_file_line.keys())

    @property
    def get_common_file_prefix(self) -> str:
        if not self.unique_files:
            return ""
        prefix = self.unique_files[0]
        for s in self.unique_files[1:]:
            while not s.startswith(prefix):
                prefix = prefix[:-1]
                if not prefix:
                    return ""
        return prefix

