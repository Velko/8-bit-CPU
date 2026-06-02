bios.hex: bios.bin
	od -An -v -tx1 bios.bin > bios.hex

bios.bin: bios.asm uart.asm convert.asm
	customasm bios.asm -- -f symbols -o bios.def.tmp
	customasm -f addrspan $< -o $@.addrmap
	../tools/addrmap-abspaths.py $@.addrmap
	grep -v "\." bios.def.tmp > bios.def


clean:
	rm -rf *.bin *.hex *.tmp *.addrmap
