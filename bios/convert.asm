b_to_hex:
    andi A, 0x0F

    cmpi A, 10
    bcc .add_a

    addi A, "0"
    jmp .done
.add_a:
    addi A, "A"-10

.done:
    ret



b_to_dec:
    clr B       ; initialize 2 lowest digits

    ; calculate N and Z flags for the input. Z is used to detect special
    ; case, N helps to identify the beginning of significant bits
    andi A, 0xFF; TODO: use TST instruction ??
    beq .done   ; (optimization) exit if zero

    ; preserve helper registers
    push D
    push C

    push B      ; store 0 as initial "previous" carry

    ldi C, 8    ; bit counter

    ; (optimization) skip leading zero bits
.leading0_loop:
    bmi .bits_loop
    dec C
    add A, A    ; shift left, updates N flag
    jmp .leading0_loop

    ; process significant bits
.bits_loop:
    ; carry-adjust lower nibble
    ldi D, 0x0F
    and D, B
    cmpi D, 0x05
    bcs .add03_skip
    addi B, 0x03
.add03_skip:

    ; higher nibble
    cmpi B, 0x50
    bcs .add30_skip
    addi B, 0x30
.add30_skip:

    ; load previous carry and shift both initial number and decode result.
    ; Carry from B will roll into A on next iteration, storing the 100s place
    popf
    adc A, A
    adc B, B
    pushf

    ; next bit
    dec C
    bne .bits_loop

    ; pull out final carry and shift into A
    popf
    adc A, A

    ; restore helper registers
    pop C
    pop D

.done:
    ret
