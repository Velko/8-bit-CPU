#!/bin/sh

avr-gcc -mmcu=atmega328p -x c -S -O3 math_ops.ctmpl -o math_ops.s