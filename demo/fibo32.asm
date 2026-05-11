#include "velkocpu.def"

start:
    lea SP, stack

    call print_a
    call print_b

fibo_loop:
    call add_ab
    call add_ba

    jmp fibo_loop

; ---------------------------------------------------------------------------------------
print_a:
    lea SDP, num_a
    jmp print_n

print_b:
    lea SDP, num_b
    ; fall through to print_n

print_n:
    push LR

    ldi C, 3
    lea TDP, number
cp_a_loop:
    ld A, (SDP + C)
    st (TDP + C), A
    dec C
    bpl cp_a_loop

    call convert_number
    call print_digits

    pop LR
    ret

print_res_a:
    call convert_number
    call print_digits

    pop LR
    ret

; ---------------------------------------------------------------------------------------
add_ab:
    lea SDP, num_a
    lea TDP, num_b
    jmp add_st

add_ba:
    lea SDP, num_b
    lea TDP, num_a
    ; fallthrough to add_st

add_st:
    push LR

    clr A
    push A
    ldi C, 3
sum_b_loop:
    ld A, (SDP + C)
    ld B, (TDP + C)
    popf
    adc A, B
    pushf
    st (SDP + C), A
    dec C
    bpl sum_b_loop

    popf

    bcc print_res

    hlt

print_res:
    call print_n

    pop LR
    ret


; ---------------------------------------------------------------------------------------
convert_number:
    clr A
    ldi C, 9
    lea TDP, digits
digits_zero_loop:
    st (TDP + C), A
    dec C
    bpl digits_zero_loop


    ldi D, 32  ; repeat for each bit
    ldi B, 5   ; for comparison
    lea SDP, number
    lea TDP, digits

double_loop:
    push D
    ldi D, 123 ; to add if >= 5

    ; push initial flags value (C = 0)
    clr A
    push A

    ldi C, 3  ; index in number[]
num_shift_loop:
    ld A, (SDP + C)
    popf  ; load flags (initial C = 0, or one from previous iteration)
    adc A, A
    st (SDP + C), A

    pushf  ; store for next iteration

    ; next number[]
    dec C
    bpl num_shift_loop

    ; now number[] is shifted left one place, flags with C bit on stack

    ldi C, 9  ; index in digits[]
add3_shift_loop:

    ; check each digit if >=5
    ld A, (TDP + C)
    cmp A, B

    bcs add3_skip

    ; adjust it for '10s carry'
    add A, D

add3_skip:

    ; now shift
    popf  ; load flags (one from previous iteration)
    adc A, A
    st (TDP + C), A

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
    ldi C, 9

to_char_loop:

    ld A, (TDP + C)
    or A, B
    st (TDP + C), A

    dec C
    bpl to_char_loop

    ret

; ---------------------------------------------------------------------------------------
print_digits:
    ; find first non-0 digit
    ldi B, 0x30 ; code of '0'
    ldi D, 9  ; upper limit for search
    lea SDP, digits
    clr C
find0_loop:
    ld A, (SDP + C)
    cmp A, B
    bne found_non0

    inc C
    cmp C, D
    bne find0_loop

found_non0:
    ld A, (SDP + C)
    beq print_end
    out DISPLAY_CHR_DATA, A
    inc C
    jmp found_non0

print_end:
    ldi A, 10 ; \n
    out DISPLAY_CHR_DATA, A

    ret

; digits[] and number[] should be placed next to each other, as number[] serves
; as \0 separator after conversion is complete
digits:
    #d8 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
number:
    #d32 36324058  ; Big endian format

num_a:
    #d32    0
num_b:
    #d32    1

stack_end:
    #res 16
stack:
