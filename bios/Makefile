bios.hex: bios.bin
	od -An -v -tx1 bios.bin > bios.hex

bios.bin: bios.asm
	customasm bios.asm

clean:
	rm -rf *.bin *.hex
