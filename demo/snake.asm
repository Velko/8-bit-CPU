#include "velkocpu.def"

ARENA_WIDTH = 40
ARENA_HEIGHT = 40
ARENA_ROW   = 64

DIR_UP = 0x02
DIR_LEFT = 0x03
DIR_DOWN = 0x04
DIR_RIGHT = 0x05

CELL_EMPTY  =  0x00
CELL_WALL   =  0x01
CELL_SNAKE_UP    = DIR_UP
CELL_SNAKE_LEFT  = DIR_LEFT
CELL_SNAKE_DOWN  = DIR_DOWN
CELL_SNAKE_RIGHT = DIR_RIGHT
CELL_FOOD   =  0x06

KEY_UP = 0x41
KEY_RIGHT = 0x43
KEY_DOWN = 0x42
KEY_LEFT = 0x44

startup:
    ; prepare and clear the screen
    lea SDP, clrscr_message
    call b_uart_puts

    ; preparing takes some time, so put a "Loading..." message on the screen
    lea SDP, loading_message
    call b_uart_puts

    ; clear the arena
    lea TDP, arena
    ldi A, CELL_EMPTY
    ; arena is 2560 bytes, so we need a double loop to count the bytes
    ldi C, 0
    ldi D, ARENA_ROW*ARENA_HEIGHT / 256
.zero_arena_loop:
    st (TDP++), A
    inc C
    bne .zero_arena_loop
    dec D
    bne .zero_arena_loop

    ; fill horizontal walls
    ldi C, ARENA_WIDTH
    lea SDP, arena
    lea TDP, arena + (ARENA_HEIGHT - 1) * ARENA_ROW
    ldi A, CELL_WALL
.fill_h_loop:
    st (SDP++), A
    st (TDP++), A
    dec C
    bne .fill_h_loop

    ; fill vertical walls
    ldi C, ARENA_HEIGHT
    ldi B, arena[7:0]
    ldi D, arena[15:8]
.fill_v_loop:
    push D
    push B
    pop TDP

    st TDP, 0, A
    st TDP, ARENA_WIDTH-1, A

    addi B, ARENA_ROW
    adci D, 0
    dec C
    bne .fill_v_loop

    ; draw the frame
    call draw_h_border
    call draw_v_borders
    call draw_h_border

    ; BCD encoded center of the screen, coordinates are 1-based
    ldi A, 0x41
    st head_xscreen, A
    st tail_xscreen, A

    ldi A, 0x21
    st head_yscreen, A
    st tail_yscreen, A

    ; precalculate the address of the center row
    ARENA_CENTER_ROW = arena + ARENA_HEIGHT * ARENA_ROW / 2
    ldi A, ARENA_CENTER_ROW[7:0]
    ldi B, ARENA_CENTER_ROW[15:8]

    st head_rowptr + 0, A
    st head_rowptr + 1, B

    st tail_rowptr + 0, A
    st tail_rowptr + 1, B

    ; binary encoded X offset into the row
    ldi A, ARENA_WIDTH / 2
    st head_xscreenoffset, A
    st tail_xscreenoffset, A

    ; initial direction
    ldi A, DIR_RIGHT
    st direction, A

    ; initial length
    ldi A, 0
    st snake_length, A

    ; initial desired length
    ldi A, 5
    st desired_length, A

    ; init PRNG (fixed values, will add entropy from user input)
    ldi A, 0x01
    st rand_a, A
    ldi A, 0x02
    st rand_b, A
    ldi A, 0x03
    st rand_c, A
    clr A
    st rand_x, A
    st seed_counter, A
    call rnd8

    ; put initial piece of food somewhere (is there a risk that erasing the Loading will hide it visually?)
    call place_food

    ; erase the "Loading..."
    lea SDP, clear_loading
    call b_uart_puts

.game_loop:

    ; run counter for PRNG entropy
    ld A, seed_counter
    inc A
    st seed_counter, A

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
    ; the result of a XOR between opposites always produces 6
    ld A, direction
    xor A, B
    cmpi A, 6
    beq .game_loop
    st direction, B

    ; direction was updated, mix in the entropy
    ld A, rand_a
    ld B, seed_counter
    xor A, B
    st rand_a, A

    jmp .game_loop

.move_head:

    ; load row ptr and calculate next one
    ld D, direction
    ld B, head_rowptr + 0
    ld C, head_rowptr + 1

    ; store the direction in "old" cell, before moving
    push C
    push B
    pop TDP
    ld A, head_xscreenoffset
    st (TDP+A), D

    call decode_direction

    ; move the row ptr and store it
    call calc_move_ptr
    st head_rowptr + 0, B
    st head_rowptr + 1, C

    ; save C:B to be picked up later
    push C
    push B

    ; move the x offset
    ld C, head_xscreenoffset
    call calc_move_offset
    st head_xscreenoffset, C

    ; move screen coordinates
    ld C, head_xscreen
    ld B, head_yscreen
    call calc_move_screen
    st head_xscreen, C
    st head_yscreen, B

.check_collision:
    ; load C:B into SDP (was pushed earlier)
    pop SDP

    ld C, head_xscreenoffset
    ld A, (SDP + C)
    beq .collision_avoided ; if anything but EMPTY=0, ran into something
    cmpi A, CELL_FOOD      ; was that FOOD?
    bne game_over          ; something else

    ; food makes snake grow
    ld A, desired_length
    inc A
    st desired_length, A

    ; place a new piece of food and let snake to move on, consuming one it just found
    call place_food

.collision_avoided:

.check_length_grow:
    ld A, snake_length
    ld B, desired_length

    cmp A, B

    beq .move_tail

    inc A
    st snake_length, A
    jmp .skip_move_tail

.move_tail:
    ; load TDP from tail ptr
    ld B, tail_rowptr + 0
    ld C, tail_rowptr + 1
    push C
    push B
    pop TDP

    ; load direction from arena
    ld A, tail_xscreenoffset
    ld D, (TDP + A)

    ; erase tail from arena
    push B
    ldi B, CELL_EMPTY
    st (TDP + A), B
    pop B

    call decode_direction

    ; move the tail and store ptr
    call calc_move_ptr
    st tail_rowptr + 0, B
    st tail_rowptr + 1, C

    ld C, tail_xscreenoffset
    call calc_move_offset
    st tail_xscreenoffset, C

    ; move screen coordinates
    ld C, tail_xscreen
    ld B, tail_yscreen
    call calc_move_screen
    st tail_xscreen, C
    st tail_yscreen, B

.skip_move_tail:

.draw_snake:
    ; build a sequence of ANSI codes to draw new head and erase old tail
    lea TDP, buffer
    call draw_head
    call erase_tail
    ldi A, 0 ; 0-terminate
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
; Calculate next screen coordinates depending on direction
; Parameters:
;   B - BCD encoded Y coordinate
;   C - BCD encoded X coordinate
;   A - 0 to move vertically, 1 - horizontally
;   D - -1 or 1, depending on direction
; Post state:
;   B - updated Y coordinate
;   C - updated X coordinate
;   A - clobbered
; ********************************************************************************
calc_move_screen:
    tst A ; get Z flag from A
    bne .move_x

.move_y:
    add B, D
    ldi A, 0x0F
    tst D ; get N flag
    bmi .y_dec
    and A, B
    cmpi A, 10
    bcs .y_done
    addi B, 6
    ret
.y_dec:
    and A, B
    cmpi A, 10
    bcs .y_done
    subi B, 6
    ret
.y_done:
    ret

.move_x:
    add C, D
    add C, D
    ldi A, 0x0F
    tst D ; get N flag
    bmi .x_dec
    and A, C
    cmpi A, 10
    bcs .x_done
    addi C, 6
    ret
.x_dec:
    and A, C
    cmpi A, 10
    bcs .x_done
    subi C, 6
    ret
.x_done:
    ret

; ********************************************************************************
; Calculate next row offset depending on direction
; Parameters:
;   C - X coordinate
;   A - 0 to move vertically, 1 - horizontally
;   D - -1 or 1, depending on direction
; Post state:
;   C - updated X coordinate
;   A, D - unchanged
; ********************************************************************************
calc_move_offset:
    tst A ; get Z flag from A
    bne .move_off_x
    ret
.move_off_x:
    add C, D
    ret

; ********************************************************************************
; Calculate next row pointer depending on direction
; Parameters:
;   B - LSB of the row pointer
;   C - MSB of the row pointer
;   A - 0 to move vertically, 1 - horizontally
;   D - -1 or 1, depending on direction
; Post state:
;   B - adjusted LSB of the row pointer
;   C - adjusted MSB of the row pointer
;   A, D - unchanged
; ********************************************************************************
calc_move_ptr:
    tst A
    bne .keep_ptr

    tst D
    bmi .dec_ptr

.inc_ptr:
    addi B, ARENA_ROW
    adci C, 0
    ret

.dec_ptr:
    subi B, ARENA_ROW
    sbbi C, 0
    ret

.keep_ptr:
    ; moves horizontally: keep the ptr as-is
    ret


; ********************************************************************************
; Decode direction into vertical/horizontal and offset
; Parameters:
;   D - direction DIR_*
; Post state:
;   A - 0 - vertically, 1 - horizontally
;   D - -1 or 1, whether to increment or decrement
; ********************************************************************************
decode_direction:
    ; the direction is in range [2 .. 5], the LSB marks the horizontal vs vertical
    ; then the opposites are 2 places apart, we can subtract 3 or 4 to get -1 or 1
    ldi A, 1
    and A, D
    bne .horizontal

.vertical:
    subi D, 3
    ret

.horizontal:
    ; adjust D to the expected range
    subi D, 4
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
;   (head_xscreen, head_yscreen) into a text buffer
; Parameters:
;   TDP - text buffer to write
; Post state:
;   TDP - buffer, past the last character written
; ********************************************************************************
draw_head:
    ld B, head_yscreen
    ld C, head_xscreen
    ldi D, "@"
    jmp draw_block


; ********************************************************************************
; Put ANSI codes and text to draw erase segment at coordinates from variables
;   (tail_xscreen, tail_yscreen) into a text buffer
; Parameters:
;   TDP - text buffer to write
; Post state:
;   TDP - buffer, past the last character written
; ********************************************************************************
erase_tail:
    ld B, tail_yscreen
    ld C, tail_xscreen
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
    call buffer_put_bcd

    ldi A, ";"
    st (TDP++), A

    mov A, C
    call buffer_put_bcd

    ldi A, "H"
    st (TDP++), A

    st (TDP++), D
    st (TDP++), D

    pop LR
    ret

; ********************************************************************************
; Put BCD-encoded value into a text buffer
; Parameters:
;   TDP - text buffer to write
;   A   - BCD-encoded number
; Post state:
;   TDP - buffer, past the last character written
; ********************************************************************************
buffer_put_bcd:
    push B
.tens:
    ; extract 10s
    ldi B, 0xF0
    and B, A
    beq .ones
    swap B
    addi B, "0"
    st (TDP++), B
.ones:
    ; extract 1s
    ldi B, 0x0F
    and B, A
    addi B, "0"
    st (TDP++), B
    pop B
    ret


; ********************************************************************************
; Place a piece of food in random non-occupied cell
; Parameters:
;   None
; Post state:
;   A, B, C, D - clobbered
;   random EMPTY cell in Arena set to FOOD
;   food drawn on the screen
; ********************************************************************************
place_food:
    push LR

.retry:
    ; get random row in [1 .. 38] range
    call rnd8
    call reduce_to_38
    inc A

    ; store for later, will need for screen coordinate calculation
    push A

    ; multiply by 64 (C:A << 6), offset for row pointer
    ;  40  =           1 0   1 0 0 0
    ; from         7 6 5 4   3 2 1 0
    add A, A
    add A, A     ; 5 4 3 2   1 0 * *
    swap A       ; 1 0 * *   5 4 3 2
    mov C, A
    andi C, 0x0F ; * * * *   5 4 3 2
    andi A, 0xC0 ; 0 1 * *   * * * *

    ; D:B - row pointer
    ldi B, arena[7:0]
    ldi D, arena[15:8]
    add B, A
    adc D, C

    ; load into SDP
    push D
    push B
    pop SDP

    ; get random column in [1 .. 38] range
    call rnd8
    call reduce_to_38
    inc A

    ; check if EMPTY
    ld B, (SDP + A)
    beq .cell_empty

    ; cell not empty, balance out the stack and try again
    pop A
    jmp .retry

.cell_empty:

    ; place food
    ldi B, CELL_FOOD
    st (SDP + A), B

    ; convert to screen coordinates, put into C
    ; x2 + 1 -> BCD
    add A, A
    inc A
    call b_to_dec
    mov C, B

    ; get row, convert to screen, keep in B
    pop A
    inc A
    call b_to_dec

    lea TDP, buffer
    ldi D, "*"
    call draw_block

    clr A
    st (TDP++), A

    ; send it to terminal
    lea SDP, buffer
    call b_uart_puts

    pop LR
    ret

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


clrscr_message:
    #d 0x1B,"[2J", 0x1B, "[?25l", 0x1B, "[8;40;80t", 0x00 ; clear screen, hide cursor, resize to 80x40


loading_message:
    #d 0x1B, "[20;35HLoading...", 0x1B, "[1;1H", 0x00; show Loading... and, goto 1:1

clear_loading:
    #d 0x1B, "[20;35H          ", 0x00

vert_border:
    #d "##", 0x1B, "[76C##", 0x00 ; put ## move left 76 and put another ##

key_to_dir:
    #d DIR_UP, DIR_DOWN, DIR_RIGHT, DIR_LEFT

game_over_message:
    #d 0x1B, "[10;10HGame over !", 0x00


#bankdef bss
{
    addr = 0x1000
}

head_xscreen:
    #res 1
head_yscreen:
    #res 1
head_rowptr:
    #res 2
head_xscreenoffset:
    #res 1
tail_xscreen:
    #res 1
tail_yscreen:
    #res 1
tail_rowptr:
    #res 2
tail_xscreenoffset:
    #res 1
direction:
    #res 1
snake_length:
    #res 1
desired_length:
    #res 1
seed_counter:
    #res 1
rand_a:
    #res 1
rand_b:
    #res 1
rand_c:
    #res 1
rand_x:
    #res 1
buffer:
    ; \[00;00H@@\[00;00H@@0
    ; 1234567890123456789012
    #res 24


#align 64
arena:
    #res ARENA_ROW*ARENA_HEIGHT
