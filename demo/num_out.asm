#include "velkocpu.def"

    ldi C, 0
next_unsigned:
    out DISPLAY_NUM_UNSIGNED, C
    inc C
    bcc next_unsigned

next_signed:
    out DISPLAY_NUM_SIGNED, C
    inc C
    bcc next_signed

next_hex:
    out DISPLAY_NUM_HEX, C
    inc C
    bcc next_hex

next_oct:
    out DISPLAY_NUM_OCT, C
    inc C
    bcc next_oct

    hlt

