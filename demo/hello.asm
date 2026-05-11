#include "velkocpu.def"

    lea SDP, message
print_loop:
    lpi A, (SDP++)
    beq end
    out DISPLAY_CHR_DATA, A
    jmp print_loop
end:
    hlt


message:
#d "Hello, World!\n\0"
