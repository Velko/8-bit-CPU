#include "velkocpu.def"

start:
    ldi A, 0
    ldi B, 1

    iout A
    iout B

next:
    add A, B
    bcs end
    iout A

    add B, A
    bcs end
    iout B

    jmp next

end:
    hlt