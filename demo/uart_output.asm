#include "velkocpu.def"

main:
    lea SDP, message
    call b_uart_puts

    ldi C, 0
next_dec:
    mov A, C
    call b_uart_putdec
    ldi A, "\r"
    out UART_DATA, A
    ldi A, "\n"
    out UART_DATA, A
    inc C
    bcc next_dec

    ldi C, 0
next_hex:
    mov A, C
    call b_uart_puthex
    ldi A, "\r"
    out UART_DATA, A
    ldi A, "\n"
    out UART_DATA, A
    inc C
    bcc next_hex

    hlt

message:
#d "Hellorld!\r\n", 0x00
