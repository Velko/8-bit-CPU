#include "velkocpu.def"

ARENA_WIDTH = 40
DIR_UP = 0
DIR_RIGHT = 1
DIR_DOWN = 2
DIR_LEFT = 3

KEY_UP = 0x41
KEY_RIGHT = 0x43
KEY_DOWN = 0x42
KEY_LEFT = 0x44

    lea SDP, clrscr_message
    call b_uart_puts

    call draw_h_border
    call draw_v_borders
    call draw_h_border

    ldi A, ARENA_WIDTH / 2
    st head_x, A
    st head_y, A
    st tail_y, A
    subi A, 4
    st tail_x, A


    ldi A, DIR_RIGHT
    st direction, A
    st next_direction, A

    ldi C, 15
.move_loop:
    push C

    lea TDP, buffer
    call draw_head
    call erase_tail
    ldi A, 0
    st (TDP++), a
    lea SDP, buffer
    call b_uart_puts

    ld A, head_x
    inc A
    st head_x, A
    ld A, tail_x
    inc A
    st tail_x, A

    pop C
    dec C
    bne .move_loop

    lea SDP, goto_10
    call b_uart_puts

listen:
    in A, UART_DATA
    bmi listen
    call b_uart_puthex
    ldi A, 0x20
    call b_uart_putc
    jmp listen



    hlt


draw_h_border:
    push LR

    ldi A, 35 ; #
    ldi C, ARENA_WIDTH * 2
.loop:
    call b_uart_putc
    dec C
    bne .loop

    pop LR
    ret


draw_v_borders:
    push LR

    ldi C, ARENA_WIDTH - 2
.loop:
    lea SDP, vert_border
    call b_uart_puts
    dec C
    bne .loop

    pop LR
    ret


draw_head:
    ld B, head_y
    ld C, head_x
    ldi D, 0x40 ; '@'
    jmp draw_block

erase_tail:
    ld B, tail_y
    ld C, tail_x
    ldi D, 0x20 ; ' '
    ; fallthrough to draw_block

draw_block:
    push LR

    ldi A, 0x1B
    st (TDP++), A
    ldi A, 0x5B ; '['
    st (TDP++), A

    mov A, B
    call buffer_putdec

    ldi A, 0x3B ; ';'
    st (TDP++), A

    mov A, C
    add A, A ;
    call buffer_putdec

    ldi A, 0x48 ; 'H'
    st (TDP++), A

    st (TDP++), D
    st (TDP++), D

    pop LR
    ret


buffer_putdec:
    push LR
    push B
    push C

    ; preserve argument and convert to BCD
    mov C, A
    call b_to_dec

    ; decide on which digit to begin (optimized for only 1 or 2 digits)
    cmpi C, 10
    bcs .put_1s

    ; pull from BCD, convert to ASCII and add to buffer
.put_10s:
    mov A, B
    swap A
    andi A, 0x0F
    addi A, "0"
    st (TDP++), A

.put_1s:
    andi B, 0x0F;
    addi B, "0"
    st (TDP++), B

    pop C
    pop B
    pop LR
    ret


clrscr_message:
    #d 0x1B,"[2J", 0x1B, "[?25l", 0x1B, "[8;40;80t", 0x1B, "[0;0H", 0x00 ; clear screen, hide cursor, resize to 80x40, goto 0:0

vert_border:
    #d "##", 0x1B, "[76C##", 0x00 ; put ## move left 76 and put another ##

goto_10:
    #d 0x1B, "[10;10H", 0x00


head_x:
    #res 1
head_y:
    #res 1
tail_x:
    #res 1
tail_y:
    #res 1
direction:
    #res 1
next_direction:
    #res 1

buffer:
    ; \[00;00H@@\[00;00H@@0
    ; 1234567890123456789012
    #res 24


#align 64
arena:
    #res 64*40
