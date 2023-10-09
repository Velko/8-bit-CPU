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

;# there are small shortcomings:
;# * A += B can wrap around briefly. It's still Ok, because the extra bit
;#   ends up in Carry flag, and we can still recover that using ROR for the
;"   subsequent shift;
;# * there is no instruction to check the last bit of A, we have to do an AND
;#   against another register (presumably D). It takes few instructions to
;#   save/restore the D, and load 1 into it. And then we have to set up stack;
;#
;# So instead we rewrite it as follows:
;
;    for D in range(16):
;        B = D
;        A = B
;        B <<= 3 # one less, because we're going to add AFTER the shift
;        for C in range(4):
;            A, carry = A >> 1, A & 1 != 0  # this is actually a single instruction: shr A
;            if carry:                      # the last bit ended up in a Carry flag
;                A += B                     # there's also no wrap-around issue
;
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

        out DISPLAY_NUM_DATA, A

        inc D
        ldi A, 16
        cmp D, A
        bcs next_base

    hlt
