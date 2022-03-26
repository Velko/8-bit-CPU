#!/usr/bin/python3

import subprocess
import os.path

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
            print(cpres.stderr.decode())

        lsres = subprocess.run(['customasm', os.path.basename(self.main_file), '-f', 'addrspan', '-o', os.path.basename(self.lst_file)], cwd=path, capture_output=True)

        if lsres.returncode != 0:
            print(lsres.stderr.decode())

