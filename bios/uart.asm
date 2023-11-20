; ********************************************************************************
; Send null-terminated string via UART
; Parameters:
;   SDP - pointer to a string to send
; Post state:
;   SDP points to null-terminating character
; ********************************************************************************
b_uart_puts:
    push A
.loop:
    lpi A, (SDP++)
    beq .done
    out UART_DATA, A
    jmp .loop
.done:
    pop A
    ret

; ********************************************************************************
; Send hexadecimal representation of 8-bit value via UART
; Parameters:
;   A - value to send
; Post state:
;   A - ASCII of last character sent
; ********************************************************************************
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

; ********************************************************************************
; Send decimal representation of 8-bit value via UART
; Parameters:
;   A - value to send
; Post state:
;   A - ASCII of last character sent
; ********************************************************************************
b_uart_putdec:
    push LR
    push B
    push C

    ; preserve argument and convert to BCD
    mov C, A
    call b_to_dec

    ; decide on which digit to begin
    cmpi C, 100
    bcc .put_100s
    cmpi C, 10
    bcc .put_10s
    jmp .put_1s

    ; pull from BCD, convert to ASCII and send
.put_100s:
    andi A, 0x0F
    addi A, "0"
    out UART_DATA, A

.put_10s:
    mov A, B
    swap A
    andi A, 0x0F
    addi A, "0"
    out UART_DATA, A

.put_1s:
    mov A, B
    andi A, 0x0F;
    addi A, "0"
    out UART_DATA, A

    pop C
    pop B
    pop LR
    ret
