#include "velkocpu.def"

start:
    lea SP, stack

    call convert_number
    call print_digits

    hlt

; ---------------------------------------------------------------------------------------
convert_number:
    ldi D, number_len * 8  ; repeat for each bit
    ldi B, 5   ; for comparison

double_loop:
    push D
    ldi D, 123 ; to add if >= 5

    ; push initial flags value (C = 0)
    clr A
    push A

    ldi C, number_len - 1  ; index in number[]
num_shift_loop:
    ldx A, number, C
    popf  ; load flags (initial C = 0, or one from previous iteration)
    adc A, A
    stx number, C, A

    pushf  ; store for next iteration

    ; next number[]
    dec C
    bpl num_shift_loop

    ; now number[] is shifted left one place, flags with C bit on stack

    ldi C, digits_len - 1  ; index in digits[]
add3_shift_loop:

    ; check each digit if >=5
    ldx A, digits, C
    cmp A, B

    bcs add3_skip

    ; adjust it for '10s carry'
    add A, D

add3_skip:

    ; now shift
    popf  ; load flags (one from previous iteration)
    adc A, A
    stx digits, C, A

    pushf  ; store for next iteration

    ; next digits[]
    dec C
    bpl add3_shift_loop

    pop A ; discard last flags on stack

    ; next outer loop iteration
    pop D
    dec D
    bne double_loop

    ; convert contents of digits to ASCTI characters
    ldi B, 0x30 ; code of '0'
    ldi C, digits_len - 1

to_char_loop:

    ldx A, digits, C
    or A, B
    stx digits, C, A

    dec C
    bpl to_char_loop

    ret

; ---------------------------------------------------------------------------------------
print_digits:
    ; find first non-0 digit
    ldi B, 0x30 ; code of '0'
    ldi D, digits_len - 1  ; upper limit for search (keep last digit)
    clr C
find0_loop:
    ldx A, digits, C
    cmp A, B
    bne found_non0

    inc C
    cmp C, D
    bne find0_loop

found_non0:
    ldx A, digits, C
    beq print_end
    cout A
    inc C
    jmp found_non0

print_end:
    ldi A, 10 ; \n
    cout A

    ret

; digits[] and number[] should be placed next to each other, as number[] serves
; as \0 separator after conversion is complete
digits:
    #d8 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
digits_len = $ - digits

number:
    #d32 36324058  ; Big endian format
number_len = $ - number

stack_end:
    #res 16
stack:
