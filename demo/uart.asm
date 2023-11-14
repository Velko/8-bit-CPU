#include "velkocpu.def"

; To run the program, upload it to the CPU and reset it, but do not send "run" command.
; Then issue the command R from minicom session.

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

message:
#d "\x1B[13;35HHellorld!\r\n\0"
