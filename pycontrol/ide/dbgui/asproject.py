#!/usr/bin/python3

import subprocess
import os.path
import re

class AsProject:
    def __init__(self, main_file: str):
        self.main_file = main_file

        no_ext = os.path.splitext(self.main_file)[0]

        self.bin_file = f'{no_ext}.bin'
        self.lst_file = f'{no_ext}.lst'

    def compile(self):
        path = os.path.abspath(os.path.dirname(self.main_file))
        cpres = subprocess.run(['customasm', os.path.basename(self.main_file), '-f', 'binary', '-o', os.path.basename(self.bin_file)], cwd=path, capture_output=True)

        if cpres.returncode != 0:
            self.parse_errors(cpres.stderr.decode())
            return

        lsres = subprocess.run(['customasm', os.path.basename(self.main_file), '-f', 'addrspan', '-o', os.path.basename(self.lst_file)], cwd=path, capture_output=True)

        if lsres.returncode != 0:
            print(lsres.stderr.decode())

    ANSI_ESCAPE = re.compile(r'(\x9B|\x1B\[)[0-?]*[ -\/]*[@-~]')
    ERROR_HEADER_RX = re.compile("^error:\s(.*)")
    ERROR_LOCATION_RX = re.compile("^\s*-->\s*(.+?):(\d+):(\d+)")

    def parse_errors(self, errors: str):
        for line in errors.splitlines():
            line = AsProject.ANSI_ESCAPE.sub("", line)
            mh = AsProject.ERROR_HEADER_RX.match(line)
            if mh:
                print(mh.group(1))

            ml = AsProject.ERROR_LOCATION_RX.match(line)
            if ml:
                print(ml.group(1), ml.group(2), ml.group(3))

        print()
        print (errors)


