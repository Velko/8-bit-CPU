from dataclasses import dataclass
import re

#; physical address : bit offset | logical address | file : line start : column start : line end : column end
#0:0 | e000 | bios.asm:20:0:20:8
#0:0 | e000 | bios.asm:21:4:21:12
HEADER_LINE = "; physical address : bit offset | logical address | file : line start : column start : line end : column end"
LINE_REGEX = r"([0-9a-fA-F]+):(\d+)\s*\|\s*([0-9a-fA-F]+)\s*\|\s*([^:]+):(\d+):(\d+):(\d+):(\d+)"

@dataclass
class AddressMapping:
    physical_address: int
    bit_offset: int
    logical_address: int
    file: str
    line_start: int
    column_start: int
    line_end: int
    column_end: int

def parse_address_mapping(line: str) -> AddressMapping:
    match = re.match(LINE_REGEX, line)
    if not match:
        raise ValueError(f"Invalid address mapping line: {line}")

    physical_address = int(match.group(1), 16)
    bit_offset = int(match.group(2))
    logical_address = int(match.group(3), 16)
    file = match.group(4)
    line_start = int(match.group(5))
    column_start = int(match.group(6))
    line_end = int(match.group(7))
    column_end = int(match.group(8))

    return AddressMapping(
        physical_address=physical_address,
        bit_offset=bit_offset,
        logical_address=logical_address,
        file=file,
        line_start=line_start,
        column_start=column_start,
        line_end=line_end,
        column_end=column_end
    )

def load_address_mappings(file_path: str) -> list[AddressMapping]:
    mappings = []
    with open(file_path, 'r') as f:
        header = f.readline().strip()
        if header != HEADER_LINE:
            raise ValueError(f"Invalid header in address mapping file: {header}")
        
        for line in f:
            line = line.strip()
            if line:
                try:
                    mapping = parse_address_mapping(line)
                    mappings.append(mapping)
                except ValueError as e:
                    print(f"Warning: {e}")
    return mappings
