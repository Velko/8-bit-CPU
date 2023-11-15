#include "velkocpu.def"

; To run the program, upload it to the CPU and reset it, but do not send "run" command.
; Then issue the command R from minicom session.

    ; move cursor \x1B[13;35H
    lea SDP, csi
    call b_uart_puts

    ldi A, 13
    call b_uart_putdec
    ldi A, ";"
    out UART_DATA, A
    ldi A, 35
    call b_uart_putdec
    ldi A, "H"
    out UART_DATA, A

    ; print "message"
    lea SDP, message
    call b_uart_puts

repeat:
    ; continue with receiving chars from UART and echoing back their hex values
    ; until tilde ~ symbol is received

    ; wait for char
    in B, UART_STATUS
    beq repeat

    ; read
    in A, UART_DATA

    ; check for exit symbol
    cmpi A, "~"
    beq exit

    call b_uart_puthex

    ; space
    ldi A, " "
    out UART_DATA, A

    jmp repeat

exit:
    hlt

csi:
#d "\x1B[", 0x00

message:
#d "Hellorld!\r\n", 0x00
