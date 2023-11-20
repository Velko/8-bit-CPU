#!/bin/sh

cd $(dirname $0)/../pycontrol/tools
echo "CustomASM definitions"
./casmdefs.py
echo "Microcode C files"
./ucode2c.py
echo "Microcode ROM files"
./microcode.py

cd ../../include
sha256sum control_rom*.bin > control_roms.sha256

cd ../bios
echo "BIOS ROM"
make clean
make

cd ../emulator/vm
echo "Emulator"
make clean
make

cd ../../demo
echo "Demo programs"
make clean
make
