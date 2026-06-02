#!/usr/bin/env python3

import argparse, os, re


#; physical address : bit offset | logical address | file : line start : column start : line end : column end
#0:0 | e000 | bios.asm:20:0:20:8
#0:0 | e000 | bios.asm:21:4:21:12
HEADER_LINE = "; physical address : bit offset | logical address | file : line start : column start : line end : column end"

# split the line by '|' and strip whitespace, then take first, second and third parts. Just split the third part by ':' and take the first, second, third, fourth and fifth parts as file, line start, column start, line end and column end respectively
LINE_REGEX = r"([^|\s]*)\s*\|\s*([0-9a-fA-F]+)\s*\|\s*([^:]+):(\d+):(\d+):(\d+):(\d+)"



if __name__ == "__main__":
    argument_parser = argparse.ArgumentParser(description="Add absolute paths to address mapping files")
    argument_parser.add_argument("mapping_files", nargs="+", help="Address mapping files to process")

    args = argument_parser.parse_args()

    for mapping_file in args.mapping_files:
        with open(mapping_file, 'r') as f:
            lines = f.readlines()

        if not lines or lines[0].strip() != HEADER_LINE:
            print(f"Skipping {mapping_file}: invalid header")
            continue

        updated_lines = [lines[0]]
        for line in lines[1:]:
            line = line.strip()
            if not line:
                continue
            match = re.match(LINE_REGEX, line)
            if not match:
                print(f"Skipping invalid line in {mapping_file}: {line}")
                continue

            physical_address = match.group(1)
            logical_address = match.group(2)
            file = match.group(3)
            line_start = match.group(4)
            column_start = match.group(5)
            line_end = match.group(6)
            column_end = match.group(7)

            abs_file = os.path.abspath(file)
            updated_line = f"{physical_address} | {logical_address} | {abs_file}:{line_start}:{column_start}:{line_end}:{column_end}\n"
            updated_lines.append(updated_line)

        with open(mapping_file, 'w') as f:
            f.writelines(updated_lines)

        print(f"Updated {mapping_file} with absolute paths")
