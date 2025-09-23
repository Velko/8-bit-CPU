#!/bin/sh
set -e

cd $(dirname $0)/../emulator/tests
make clean
make

cd ../../pycontrol
./mypy_check.sh

../tools/start_emu.sh
python3 -m pytest


cd ../demo

../tools/exec_bin.py hello.bin | grep -q "Hello, World!"
../tools/exec_bin.py prime_sieve.bin | diff -u primes.txt -
../tools/exec_bin.py double_dabble.bin | grep -q "36324058"
../tools/exec_bin.py -M uart_output.bin | diff -u uart_output.txt -


kill -- -$$
