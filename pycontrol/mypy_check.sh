#!/bin/sh

export MYPYPATH=stubs
python3 -m mypy libcpu
python3 -m mypy tests
