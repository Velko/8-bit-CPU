#include "velkocpu.def"
/***
  X ABC Algorithm Random Number Generator for 8-Bit Devices
  https://www.electro-tech-online.com/threads/ultra-fast-pseudorandom-number-generator-for-8-bit.124249/
  Not safe for cryptographic use!

  2025-08-04: Modified to use rotate
***/

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
    call rnd8
    out DISPLAY_NUM_DATA, C
    inc A
    bcc .loop

    hlt

; ********************************************************************************
; Generate pseudo-random number
;   rand_a, rand_b, rand_c, rand_x - RNG` state
; Post state:
;   C - random number
;   rand_a, rand_b, rand_c, rand_x - updated RNG state
; ********************************************************************************
rnd8:
    push A
    push B
    push D

    ld A, rand_a
    ld B, rand_b
    ld C, rand_c
    ld D, rand_x

    inc D
    st rand_x, D

    xor A, C
    xor A, D
    st rand_a, A

    add B, A
    st rand_b, B

    mov D, B
    shr D
    ror B
    add C, B
    xor C, A

    st rand_c, C

    pop D
    pop B
    pop A

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
