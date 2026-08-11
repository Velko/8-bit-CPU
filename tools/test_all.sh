#!/bin/sh
set -e


run_emulator_tests() {
    python3 -m pytest

    cd ../demo
    ../tools/exec_bin.py hello.bin | grep -q "Hello, World!" || echo "FAILED: hello.bin"
    ../pycontrol/tools/debugger.py -s hello.bin | grep -q "Hello, World!" || echo "FAILED: steprun hello.bin"
    ../tools/exec_bin.py prime_sieve.bin | diff -u primes.txt - || echo "FAILED: prime_sieve.bin"
    ../tools/exec_bin.py double_dabble.bin | grep -q "36324058" || echo "FAILED: double_dabble.bin"
    ../tools/exec_bin.py -M uart_output.bin | diff -u uart_output.txt - || echo "FAILED: uart_output.bin"
    cd -

    ../tools/shutdown.py
}

echo "********************** Verilog Emulator Tests **********************"
cd $(dirname $0)/../emulator/tests
make clean
make

echo "********************** Rust Emulator Tests **********************"
cd ../../turbo
cargo test

echo "********************** PyControl TypeCheck **********************"
cd ../pycontrol
./mypy_check.sh

echo "********************** PyControl Verilog Emulator Tests **********************"
../tools/start_emu.sh
run_emulator_tests

echo "********************** PyControl Rust Emulator Tests **********************"
../tools/start_turbo.sh
run_emulator_tests
