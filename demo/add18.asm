#include "instructions.def"
#include "aliases.def"
#include "ports.def"

#bankdef code ; program code
{
    #addr 0x0000
    #outp 0
    #size 0x0100
}

    ldi A, 24
    ldi B, 18
loop:
    add A, B
    out DISPLAY_NUM_DATA, A
    bcc loop

    sub A, B
subloop:
    out DISPLAY_NUM_DATA, A
    sub A, B
    bcc subloop


    clr B
print_loop:
    ldx A, msg, B
    beq done
    call print
    inc B
    jmp print_loop

done:
    hlt

#include "print.asm"

#bankdef rodata ; read-only data
{
    #addr 0x0100
    #outp 8 * 0x0100
}

msg:
    #d "Hello, World!\n\0"

#bankdef data ; variables
{
    #addr 0x0200
}

sum_res:
    #res 1
