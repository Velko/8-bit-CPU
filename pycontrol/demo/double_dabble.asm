#include "velkocpu.def"

start:
    lea (SP, stack)

    ldi (D, 32)  ; repeat for each bit
    ldi (B, 5)   ; for comparison

double_loop:
    push (D)
    ldi (D, 123) ; to add if >= 5

    ; push initial flags value (C = 0)
    clr (A)
    push (A)

    ldi (C, 3)  ; index in number[]
num_shift_loop:
    ldx (A, number, C)
    popf () ; load flags (initial C = 0, or one from previous iteration)
    adc (A, A)
    stx (number, C, A)

    pushf () ; store for next iteration

    ; next number[]
    dec (C)
    bpl (num_shift_loop)

    ; now number[] is shifted left one place, flags with C bit on stack

    ldi (C, 9)  ; index in digits[]
add3_shift_loop:

    ; check each digit if >=5
    ldx (A, digits, C)
    cmp (A, B)

    bcs (add3_skip)

    ; adjust it for '10s carry'
    add (A, D)

add3_skip:

    ; now shift
    popf () ; load flags (one from previous iteration)
    adc (A, A)
    stx (digits, C, A)

    pushf () ; store for next iteration

    ; next digits[]
    dec (C)
    bpl (add3_shift_loop)

    pop (A) ; discard last flags on stack

    ; next outer loop iteration
    pop (D)
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
