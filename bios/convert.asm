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