
b_uart_puts:
    push A
.loop:
    lpi A, SDP
    beq .done
    out UART_DATA, A
    jmp .loop
.done:
    pop A
    ret
