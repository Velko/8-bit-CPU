#!/bin/sh

export MYPYPATH=stubs
python3 -m mypy --strict libcpu
python3 -m mypy --strict tests
python3 -m mypy --strict tools
python3 -m mypy --strict ../tools
#python3 -m mypy --strict ide
