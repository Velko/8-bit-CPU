; The .def file can be generated using casmdefs.py tool
#include "velkocpu.def"

;# from https://users.utcluj.ro/~baruch/book_ssce/SSCE-Shift-Mult.pdf
;    for D in range(16):
;        B = D
;        A = B
;        B <<= 4
;        for C in range(4):
;            if A & 1 != 0:
;                A += B
;            A >>= 1

;        print (A)

squares_start:

    lea SP, stack

    clr D

next_base:
        push D

        mov B, D
        mov A, D
        swap B

        ldi C, 4
        ldi D, 1
next_bit:
            lcmp A, D
            beq skip_add
                add A, B
skip_add:
            ror A; add A, B may wrap around, but we still have the extra bit in Carry

            dec C
            bne next_bit

        out A

        pop D
        inc D
        ldi A, 16
        cmp D, A
        bcs next_base

    hlt

stack_end:
    #res 16
stack: