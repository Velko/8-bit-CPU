#include "velkocpu.def"

    ldi B, 0
print_loop:
    ldx A, message, B
    beq end
    out 4, A
    inc B
    jmp print_loop
end:
    hlt


message:
#d "Hello, World!\n\0"
