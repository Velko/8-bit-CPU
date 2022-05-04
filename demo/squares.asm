; The .def file can be generated using casmdefs.py tool
#include "velkocpu.def"


; Bootloader contains common code for ROM->RAM copy
; #include "bootloader.asm"

;# from https://users.utcluj.ro/~baruch/book_ssce/SSCE-Shift-Mult.pdf
;
;# calculate a = b * q for 4-bit arguments
;
;    a = 0
;
;    for _ in range(4):
;        if q & 1 != 0:
;            a += b
;        b <<= 1
;        q >>= 1
;
;# current hardware lacks shifter for '>>' operation
;# '<<' is not an issue, the result is same as adding to itself
;# rewrite that as:
;
;    a = 0
;    z = 1
;
;    for _ in range(4):
;        if q & z != 0:
;            a += b
;        b <<= 1
;        z <<= 1
;
;# since we're about to calculate just squares, instead of q, just use b
;
;    a = 0
;    z = 1
;
;    for _ in range(4):
;        if b & z != 0:
;            a += b
;        b <<= 1
;        z <<= 2  # we just shifted b left, shift z twice to compensate
;
;# z also becomes 256 when loop ends, can use both Z or C flags to detect


squares_start:

    clr D

next_base:
    mov B, D

    clr A
    ldi C , 1

next_bit:

    lcmp B, C ; logical compare: and B, C; update flags only

    beq skip_add

    add A, B

skip_add:

    add B, B
    add C, C
    add C, C

    bcc next_bit

    iout A

    inc D
    ldi B, 16
    cmp D, B
    bcs next_base

    hlt