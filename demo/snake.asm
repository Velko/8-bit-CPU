#include "velkocpu.def"

    lea SDP, clrscr_message
    call b_uart_puts

    call draw_h_border
    call draw_v_borders
    call draw_h_border


    lea SDP, goto_10
    call b_uart_puts

    hlt


draw_h_border:
    push LR

    ldi A, 35 ; #
    ldi C, 80
.loop:
    call b_uart_putc
    dec C
    bne .loop

    pop LR
    ret


draw_v_borders:
    push LR

    ldi C, 38
.loop:
    lea SDP, vert_border
    call b_uart_puts
    dec C
    bne .loop

    pop LR
    ret

clrscr_message:
#d 0x1B,"[2J", 0x1B, "[?25l", 0x1B, "[8;40;80t", 0x1B, "[0;0H", 0x00 ; clear screen, hide cursor, resize to 80x40, goto 0:0

vert_border:
#d "##", 0x1B, "[76C##", 0x00 ; put ## move left 76 and put another ##

goto_10:
#d 0x1B, "[10;10H", 0x00
