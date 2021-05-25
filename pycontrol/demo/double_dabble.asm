#include "velkocpu.def"

start:
    lea (SP, stack)

    ldi (D, 32) ; repeat for each bit
double_loop:

    ldi (C, 9)  ; index in digits[]
add3_loop:

    ; check each digit if >=5
    ldx (A, digits, C)
    ldi (B, 5)
    cmp (A, B)

    bcs (add3_skip)

    ; adjust it for '10s carry'
    ldi (B, 123)
    add (A, B)
    stx (digits, C, A)

add3_skip:
    dec (C)

    bpl (add3_loop)


    ; push on stack initial flags value
    clr (A)
    push (A)

    ldi (C, 13)  ; index in digits[] + number[]
shift_loop:

    ldx (A, digits, C)
    popf () ; load flags (initial C = 0, or one from previous iteration)
    adc (A, A)
    stx (digits, C, A)

    pushf () ; store for next iteration

    dec (C)
    bpl (shift_loop)

    pop (A) ; discard last flags on stack

    ; next outer loop iteration
    dec (D)
    bne (double_loop)

    ; convert contents of digits to ASCTI characters
    ldi (B, 0x30) ; code of '0'
    ldi (C, 9)
to_char_loop:

    ldx (A, digits, C)
    or (A, B)
    stx (digits, C, A)

    dec (C)
    bpl (to_char_loop)


    ; find first non-0 digit
    ; B still contains ASCII of '0'
    ldi (D, 9)  ; upper limit for search
    clr (C)
find0_loop:
    ldx (A, digits, C)
    cmp (A, B)
    bne (print_digits)

    inc (C)
    cmp (C, D)
    bne (find0_loop)

print_digits:
    ldx (A, digits, C)
    beq (print_end)
    cout (A)
    inc (C)
    jmp (print_digits)

print_end:
    ldi (A, 10) ; \n
    cout (A)

    hlt()

; digits[] and number[] should be placed next to each other, as they are sometimes accessed
; as one big array
digits:
    #d8 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
number:
    #d32 36324058  ; Big endian format

stack_end:
    #res 16
stack:
