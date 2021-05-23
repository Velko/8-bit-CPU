#include "velkocpu.def"

start:
    ldi (A, 0)
    ldi (B, 1)

    out (A)
    out (B)

next:
    add (A, B)
    bcs (end)
    out (A)

    add (B, A)
    bcs (end)
    out (B)

    jmp (next)

end:
    hlt ()