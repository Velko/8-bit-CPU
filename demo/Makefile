
all: double_dabble.bin fibo32.bin fibo.bin hello.bin hello_lcd.bin prime_sieve.bin\
	add18.bin squares2.bin squares.bin uart.bin uart_output.bin


double_dabble.bin: double_dabble.asm
	customasm double_dabble.asm

fibo32.bin: fibo32.asm
	customasm fibo32.asm

fibo.bin: fibo.asm
	customasm fibo.asm

hello.bin: hello.asm
	customasm hello.asm

hello_lcd.bin: hello_lcd.asm
	customasm hello_lcd.asm

prime_sieve.bin: prime_sieve.asm
	customasm prime_sieve.asm

add18.bin: add18.asm print.asm
	customasm add18.asm

squares2.bin: squares2.asm
	customasm squares2.asm

squares.bin: squares.asm
	customasm squares.asm

uart.bin: uart.asm
	customasm uart.asm

uart_output.bin: uart_output.asm
	customasm uart_output.asm

clean:
	rm -rf *.bin
