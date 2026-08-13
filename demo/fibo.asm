#include "velkocpu.def"

start:
    ldi A, 0
    ldi B, 1

    out DISPLAY_NUM_UNSIGNED, A
    out DISPLAY_NUM_UNSIGNED, B

next:
    add A, B
    bcs end
    out DISPLAY_NUM_UNSIGNED, A

    add B, A
    bcs end
    out DISPLAY_NUM_UNSIGNED, B

    jmp next

end:
    hlt
