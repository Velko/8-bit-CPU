bios.hex: bios.bin
	od -An -v -tx1 bios.bin > bios.hex

bios.bin: bios.asm
	customasm bios.asm -- -f symbols -o bios.def.tmp
	grep -v "\." bios.def.tmp > bios.def


clean:
	rm -rf *.bin *.hex *.tmp
