bootloader:
    ; temporary hardware configuration is such that reads
    ; comes from ROM, but writes goes into RAM
    ; bootloader loops all 256 addresses, reads in and writes
    ; back (making a copy from ROM to RAM in the process)

    ; dummy instruction, will be replaced by jmp when loading
    ; is complete
    ldi (A, program_start)

    ldi (B, 0)
.loop:
    ldabs (A, B)
    stabs (B, A)
    ldi (A, 1)
    add (B, A)
    bcc(.loop)

    ; after address wrap-around B should be 0, the address we need;
    ; replace the value there with opcode for jmp (be careful with microcode updates)
    ldi (A, 0x24)
    stabs (B, A)

; run halt in a loop in case it is not wired properly
.haltloop:
    hlt()
    jmp (.haltloop)


; the program itself
program_start:

