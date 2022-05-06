#!/usr/bin/python3

import os.path, sys

def asset_file(name: str) -> str:
    main_script = sys.argv[0]
    base_dir = os.path.dirname(main_script)
    return os.path.join(base_dir, "assets", name)

def script_file(name: str) -> str:
    main_script = sys.argv[0]
    base_dir = os.path.dirname(main_script)
    return os.path.join(base_dir, name)