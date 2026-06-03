bios.hex: bios.bin
	od -An -v -tx1 bios.bin > bios.hex

bios.bin: bios.asm uart.asm convert.asm
	customasm bios.asm -f binary -o $@ -- -f symbols -o $(basename $@).sym -- -f addrspan -o $(basename $@).addrmap
	../tools/addrmap-abspaths.py $(basename $@).addrmap
	grep -v "\." $(basename $@).sym > $(basename $@).def


clean:
	rm -rf *.bin *.hex *.sym *.addrmap
