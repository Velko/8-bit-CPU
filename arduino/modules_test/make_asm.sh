#!/bin/sh

avr-gcc -mmcu=atmega328p -x c -S -O3 alu_ref.ctmpl -o alu_ref.S