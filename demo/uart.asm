#include "velkocpu.def"

; To run the program, upload it to the CPU and reset it, but do not send "run" command.
; Then issue the command R from minicom session.

    ; print "message"
    lea SDP, message
print_loop:
    lpi A, SDP
    beq repeat
    out UART_DATA, A
    jmp print_loop

repeat:
    ; continue with receiving chars from UART and echoing back their hex values
    ; until tilde ~ symbol is received

    ; wait for char
    in B, UART_STATUS
    beq repeat

    ; read
    in C, UART_DATA

    ; check for exit symbol
    ldi B, "~"
    cmp C, B
    beq exit

    ; print high nibble
    mov A, C
    swap A
    call to_hex
    out UART_DATA, A

    ; print low nibble
    mov A, C
    call to_hex
    out UART_DATA, A

    ; space
    ldi A, " "
    out UART_DATA, A

    jmp repeat

exit:
    hlt


to_hex:
    push B

    ldi B, 0x0F
    and A, B

    ldi B, 10
    cmp A, B
    bcc .add_a

    ldi B, "0"
    add A, B
    jmp .done
.add_a:
    ldi B, "A"-10
    add A, B

.done:
    pop B
    ret

message:
#d "\x1B[13;35HHellorld!\r\n\0"
