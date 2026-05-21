#include "velkocpu.def"

;  X ABC Algorithm Random Number Generator for 8-Bit Devices
;  https://www.electro-tech-online.com/threads/ultra-fast-pseudorandom-number-generator-for-8-bit.124249/
;  Not safe for cryptographic use!

;  2025-08-04: Modified to use rotate


init_rand:
    ldi A, 0x01
    st rand_a, A
    ldi A, 0x02
    st rand_b, A
    ldi A, 0x03
    st rand_c, A
    clr A
    st rand_x, A
    call rnd8

    ldi A, 2
    out DISPLAY_NUM_MODE, A

    ldi A, 0
.loop:
    push A
    call rnd8
    call reduce_to_38
    out DISPLAY_NUM_DATA, A
    pop A
    inc A
    bcc .loop

    hlt

; ********************************************************************************
; Generate pseudo-random number
;   rand_a, rand_b, rand_c, rand_x - RNG` state
; Post state:
;   A - random number
;   B, C, D - clobbered
;   rand_a, rand_b, rand_c, rand_x - updated RNG state
; ********************************************************************************
rnd8:
    ld C, rand_a
    ld B, rand_b
    ld A, rand_c
    ld D, rand_x

    inc D
    st rand_x, D

    xor C, A
    xor C, D
    st rand_a, C

    add B, C
    st rand_b, B

    mov D, B
    shr D
    ror B
    add A, B
    xor A, C

    st rand_c, A

    ret


; ********************************************************************************
; Reduce to modulo-38
; Parameters:
;   A - input number
; Post state:
;   A - number reduced to [0 .. 38) range
; ********************************************************************************
reduce_to_38:
    ; calculate (A >> 3) + (A >> 6) + (A >> 7)
    ; 256/8 + 256/64 + 256/128 -> 32 + 4 + 2 = 38

    ; 4-bit shifted baseline
    mov B, A
    swap B       ; original_bit_3 -> bit 7
    mov C, B
    andi C, 0x0F ; x >> 4

    ; x >> 6 and x >> 7
    mov D, C
    shr D
    shr D
    mov A, D
    shr D
    add A, D

    ; x >> 3 ==  ((x >> 4) << 1) | (original_bit_3)
    add B, B
    adc C, C

    ; final assembly
    add A, c

    ret



#bankdef bss
{
    addr = 0x1000
}

rand_a:
    #res 1
rand_b:
    #res 1
rand_c:
    #res 1
rand_x:
    #res 1
