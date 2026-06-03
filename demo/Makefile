PROJECTS=double_dabble fibo32 fibo hello hello_lcd prime_sieve\
	add18 squares2 squares uart uart_output snake

BIN=$(addsuffix .bin, $(PROJECTS))

all: $(BIN)

%.bin: %.asm
	customasm -f binary $< -o $@ -- -f addrspan -o $(basename $@).addrmap -- -f symbols -o $(basename $@).sym
	../tools/addrmap-abspaths.py $(basename $@).addrmap

clean:
	rm -rf *.bin *.addrmap *.sym
