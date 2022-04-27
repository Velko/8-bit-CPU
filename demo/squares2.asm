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

    clr D

next_base:
        mov B, D
        mov A, D
        swap B
        shr B

        ldi C, 4
next_bit:
            shr A
            bcc skip_add
                add A, B
skip_add:
            dec C
            bne next_bit

        out A

        inc D
        ldi A, 16
        cmp D, A
        bcs next_base

    hlt
