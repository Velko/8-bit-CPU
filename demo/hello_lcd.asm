#include "velkocpu.def"

    ;TODO: implement initialization sequence for "real" LCD module

    ldi D, 0x80
    lea SDP, message
print_loop:
    ; wait for busy flag to clear
    ;in C, DISPLAY_LCD_CMD
    ;and C, D
    ;bne print_loop

    ; load and output next char from message, \0 terminates the string
    ld A, (SDP++)
    beq end
    out DISPLAY_LCD_DATA, A

    ; next char
    jmp print_loop

end:
    ; all done
    hlt

message:
#d "Hello, LCD!\n\0"
