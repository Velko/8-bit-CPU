#include "velkocpu.def"

; To run the program, upload it to the CPU and reset it, but do not send "run" command.
; Then issue the command R from minicom session.

    ; print "prompt"
    ldi A, "\\"
    out UART_DATA, A
    ldi A, "\r"
    out UART_DATA, A
    ldi A, "\n"
    out UART_DATA, A

repeat:
    ; wait for char
    in B, UART_STATUS
    beq repeat

    ; read and echo
    in C, UART_DATA
    out UART_DATA, C

    jmp repeat
