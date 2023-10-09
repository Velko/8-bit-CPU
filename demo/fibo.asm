#include "velkocpu.def"

start:
    ldi A, 0
    ldi B, 1

    out DISPLAY_NUM_DATA, A
    out DISPLAY_NUM_DATA, B

next:
    add A, B
    bcs end
    out DISPLAY_NUM_DATA, A

    add B, A
    bcs end
    out DISPLAY_NUM_DATA, B

    jmp next

end:
    hlt