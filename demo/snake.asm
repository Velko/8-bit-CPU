#include "velkocpu.def"

ARENA_WIDTH = 40
ARENA_HEIGHT = 40
ARENA_ROW   = 64

DIR_UP = 0x00
DIR_LEFT = 0x01
DIR_DOWN = 0x02
DIR_RIGHT = 0x03

CELL_EMPTY  =  0x00

KEY_UP = 0x41
KEY_RIGHT = 0x43
KEY_DOWN = 0x42
KEY_LEFT = 0x44

startup:
    lea SDP, clrscr_message
    call b_uart_puts

    lea SDP, loading_message
    call b_uart_puts

    ; clear the arena
    lea TDP, arena
    ldi A, CELL_EMPTY
    ldi C, 0
    ldi D, ARENA_ROW*ARENA_HEIGHT / 256
.zero_arena_loop:
    st (TDP++), A
    inc C
    bne .zero_arena_loop
    dec D
    bne .zero_arena_loop


    call draw_h_border
    call draw_v_borders
    call draw_h_border

    ldi A, ARENA_WIDTH / 2
    st head_x, A
    st tail_x, A

    ldi A, ARENA_HEIGHT / 2
    st head_y, A
    st tail_y, A

    ; precalculate the address of the center row
    ARENA_CENTER_ROW = arena + ARENA_HEIGHT * ARENA_ROW / 2
    ldi A, ARENA_CENTER_ROW[7:0]
    ldi B, ARENA_CENTER_ROW[15:8]

    st head_rowptr + 0, A
    st head_rowptr + 1, B

    st tail_rowptr + 0, A
    st tail_rowptr + 1, B

    ldi A, DIR_RIGHT
    st direction, A

    lea SDP, clear_loading
    call b_uart_puts

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
    ; allow only 90 degree turns
    ; the result of a XOR between opposites always produces 2
    ld A, direction
    xor A, B
    cmpi A, 2
    beq .game_loop
    st direction, B
    jmp .game_loop


.move_head:
    ; temporarily copy the head_rowptr to tail_rowptr
    ;ld B, head_rowptr + 0
    ;ld C, head_rowptr + 1
    ;st tail_rowptr + 0, B
    ;st tail_rowptr + 1, C

    ld C, head_x
    ld B, head_y
    ld D, direction

    ; temporarily set the tail to old location of head (snake length of 1)
    ;st tail_x, C
    ;st tail_y, B

    call calc_move

    st head_x, C
    st head_y, B

    ld B, head_rowptr + 0
    ld C, head_rowptr + 1
    add A, A ; calc flags, the idx needs to be recalculated only on vertical movement
    bne .move_ptr_done
    call calc_move_ptr
    st head_rowptr + 0, B
    st head_rowptr + 1, C
.move_ptr_done:

.mark_head_in_arena:
    ; load C:B into TDP
    push C
    push B
    pop TDP

    ld C, head_x
    ld A, (TDP + C)
    bne game_over ; if anything but EMPTY=0, ran into someting

    ld D, direction
    inc D   ; DIR_* is 0-based, but we need to reserve 0 for EMPTY, so adding 1
    st (TDP + C), D


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

game_over:
    lea SDP, game_over_message
    call b_uart_puts
    hlt


; ********************************************************************************
; Calculate next coordinates depending on direction
; Parameters:
;   B - Y coordinate
;   C - X coordinate
;   D - direction DIR_*
; Post state:
;   B - updated Y coordinate
;   C - updated X coordinate
;   A - 0, if moved vertically, 1 - if horizontally
;   D - -1 or 1, depending on direction
; ********************************************************************************
calc_move:
    ; the direction is in range [0 .. 3], the LSB marks the horizontal vs vertical
    ; then the opposites are 2 places apart, we can subtract 1 or 2 to get -1 or 1
    ldi A, 1
    and A, D
    bne .move_x

.move_y:
    dec D
    add B, D
    ret

.move_x:
    subi D, 2
    add C, D
    ret

; ********************************************************************************
; Calculate next index address depending on direction
; Parameters:
;   B - LSB of the index
;   C - MSB of the index
;   D - -1 or 1, whether to increment or decrement the row
; ********************************************************************************
calc_move_ptr:
    add D, D ; just to obtain flags
    bmi .dec_ptr

.inc_ptr:
    addi B, ARENA_ROW
    adci C, 0
    ret

.dec_ptr:
    subi B, ARENA_ROW
    sbbi C, 0
    ret

; ********************************************************************************
; Send horizontal border line via UART
; Parameters:
;   None
; Post state:
;   A, C - clobbered
; ********************************************************************************
draw_h_border:
    push LR

    ldi A, "#"
    ldi C, ARENA_WIDTH * 2
.loop:
    call b_uart_putc
    dec C
    bne .loop

    pop LR
    ret

; ********************************************************************************
; Send vertical border line via UART
; Parameters:
;   None
; Post state:
;   SDP, C - clobbered
; ********************************************************************************
draw_v_borders:
    push LR

    ldi C, ARENA_HEIGHT - 2
.loop:
    lea SDP, vert_border
    call b_uart_puts
    dec C
    bne .loop

    pop LR
    ret


; ********************************************************************************
; Put ANSI codes and text to draw snake segment at coordinates from variables
;   (head_x, head_y) into a text buffer
; Parameters:
;   TDP - text buffer to write
; Post state:
;   TDP - buffer, past the last character written
; ********************************************************************************
draw_head:
    ld B, head_y
    ld C, head_x
    ldi D, "@"
    jmp draw_block


; ********************************************************************************
; Put ANSI codes and text to draw erase segment at coordinates from variables
;   (tail_x, tail_y) into a text buffer
; Parameters:
;   TDP - text buffer to write
; Post state:
;   TDP - buffer, past the last character written
; ********************************************************************************
erase_tail:
    ld B, tail_y
    ld C, tail_x
    ldi D, " "
    ; fallthrough to draw_block


; ********************************************************************************
; Put ANSI codes and text to draw a block segment at given coordinates into a text
;   buffer
; Parameters:
;   TDP - text buffer to write
;   B - Y coordinate
;   C - X coordinate
;   D - character to write
; Post state:
;   A - clobbered
;   TDP - buffer, past the last character written
; ********************************************************************************
draw_block:
    push LR

    ldi A, 0x1B
    st (TDP++), A
    ldi A, "["
    st (TDP++), A

    mov A, B
    call buffer_putdec

    ldi A, ";"
    st (TDP++), A

    mov A, C
    add A, A ; double the coordinate, because each block is 2 chars
    call buffer_putdec

    ldi A, "H"
    st (TDP++), A

    st (TDP++), D
    st (TDP++), D

    pop LR
    ret

; ********************************************************************************
; Put decimal representation of a value into a text buffer
; Parameters:
;   TDP - text buffer to write
;   A   - number
; Post state:
;   TDP - buffer, past the last character written
;   A - clobbered
; ********************************************************************************
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
    #d 0x1B,"[2J", 0x1B, "[?25l", 0x1B, "[8;40;80t", 0x00 ; clear screen, hide cursor, resize to 80x40


loading_message:
    #d 0x1B, "[20;35HLoading...", 0x1B, "[0;0H", 0x00; show Loading... and, goto 0:0

clear_loading:
    #d 0x1B, "[20;35H          ", 0x00

vert_border:
    #d "##", 0x1B, "[76C##", 0x00 ; put ## move left 76 and put another ##

key_to_dir:
    #d DIR_UP, DIR_DOWN, DIR_RIGHT, DIR_LEFT

game_over_message:
    #d 0x1B, "[10;10HGame over !", 0x00


head_x:
    #res 1
head_y:
    #res 1
head_rowptr:
    #res 2
tail_x:
    #res 1
tail_y:
    #res 1
tail_rowptr:
    #res 2
direction:
    #res 1
buffer:
    ; \[00;00H@@\[00;00H@@0
    ; 1234567890123456789012
    #res 24


#align 64
arena:
    #res ARENA_ROW*ARENA_HEIGHT
