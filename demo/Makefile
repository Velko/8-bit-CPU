PROJECTS=double_dabble fibo32 fibo hello hello_lcd prime_sieve\
	add18 squares2 squares uart uart_output snake

all: $(PROJECTS)

.SECONDEXPANSION:
$(PROJECTS): $(BIN) $$@.bin
	@echo Making $@ from $^

%.bin: %.asm
	customasm -f binary $< -o $@
	customasm -f addrspan $< -o $@.addrmap
	../tools/addrmap-abspaths.py $@.addrmap

clean:
	rm -rf *.bin *.addrmap
