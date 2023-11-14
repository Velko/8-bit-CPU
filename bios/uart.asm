
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

b_uart_puthex:
    push LR
    push A  ; preserve A, will need once more

    ; high nibble
    swap A
    call b_to_hex
    out UART_DATA, A

    ; low nibble
    pop A
    call b_to_hex
    out UART_DATA, A

    pop LR
    ret
