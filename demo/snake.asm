#include "velkocpu.def"

ARENA_WIDTH = 40

DIR_UP = 0x00
DIR_LEFT = 0x01
DIR_DOWN = 0x02
DIR_RIGHT = 0x03

KEY_UP = 0x41
KEY_RIGHT = 0x43
KEY_DOWN = 0x42
KEY_LEFT = 0x44

startup:
    lea SDP, clrscr_message
    call b_uart_puts

    call draw_h_border
    call draw_v_borders
    call draw_h_border

    ldi A, ARENA_WIDTH / 2
    st head_x, A
    st head_y, A
    st tail_x, A
    st tail_y, A


    ldi A, DIR_RIGHT
    st direction, A
    st next_direction, A


.game_loop:

    in A, UART_DATA
    bmi .move_head  ; 0xFF means no input, only then proceed to move the snake

    ; handle key input
    ; the arrow keys are [0x41 .. 0x44], first get them into range [0 .. 3]
    subi A, KEY_UP
    bcs .game_loop ; was less than KEY_UP -> discard it

    ; now check the upper bound
    cmpi A, 4
    bcc .game_loop ; was more than 3 -> discard

    ; unfortunately the key indices does not match the desired direction constants
    ; load it from mapping table
    lea SDP, key_to_dir
    ld B, (SDP + A)

.validate_rotation:
    st direction, B

    jmp .game_loop


.move_head:

    ; temporarily set the tail to old location of head (snake length of 1)
    ld A, head_x
    ld B, head_y
    st tail_x, A
    st tail_y, B

    ; the direction is in range [0 .. 3], the LSB marks the horizontal vs vertical
    ; then the opposites are 2 places apart, we can subtract 1 or 2 to get -1 or 1
    ld D, direction
    ldi A, 1
    and A, D
    bne .move_head_x

.move_head_y:
    dec D
    ld A, head_y
    add A, D
    st head_y, A
    jmp .move_head_done

.move_head_x:
    subi D, 2
    ld A, head_x
    add A, D
    st head_x, A

.move_head_done:

.draw_snake:
    ; build a sequence of ANSI codes to draw new head and erase old tail
    lea TDP, buffer
    call draw_head
    call erase_tail
    ldi A, 0
    st (TDP++), A

    ; and send it to terminal
    lea SDP, buffer
    call b_uart_puts

    jmp .game_loop

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

key_to_dir:
    #d DIR_UP, DIR_DOWN, DIR_RIGHT, DIR_LEFT

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
