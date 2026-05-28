#include "velkocpu.def"


    ldi A, 0
next_mode:
    out DISPLAY_NUM_MODE, A

    ldi C, 0
next_number:
    out DISPLAY_NUM_DATA, C
    inc C
    bcc next_number

    inc A
    cmpi A, 4
    bne next_mode

    hlt

