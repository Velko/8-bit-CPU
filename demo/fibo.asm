#include "velkocpu.def"

start:
    ldi A, 0
    ldi B, 1

    out 0, A
    out 0, B

next:
    add A, B
    bcs end
    out 0, A

    add B, A
    bcs end
    out 0, B

    jmp next

end:
    hlt