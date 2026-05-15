#include "velkocpu.def"

    ldi A, 0
.up_loop:

    call print_bcd

    ; bcd increment
    inc A
    ldi B, 0x0F
    and B, A
    cmpi B, 10
    bcs .up_loop
    addi A, 6

    cmpi A, 0x99
    bcs .up_loop

.down_loop:
    ; bcd decrement
    dec A
    ldi B, 0x0F
    and B, A
    cmpi B, 10
    bcs .down_done
    subi A, 6

.down_done:

    call print_bcd

    addi A, 0

    bne .down_loop

    hlt

print_bcd:
.tens:
    ; extract 10s
    ldi B, 0xF0
    and B, A
    beq .ones
    swap B
    addi B, "0"
    out DISPLAY_CHR_DATA, B

.ones:
    ; extract 1s
    ldi B, 0x0F
    and B, A
    addi B, "0"
    out DISPLAY_CHR_DATA, B

    ; newline
    ldi B, "\n"
    out DISPLAY_CHR_DATA, B

    ret
