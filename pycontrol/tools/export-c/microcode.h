#ifndef MICROCODE_H
#define MICROCODE_H

#include <stdint.h>

#ifdef __AVR__
#include <avr/pgmspace.h>
#else
#define PROGMEM
#endif

#define MAX_STEPS       4
#define MAX_ALTS        1

struct op_flags_alt {
    uint8_t mask;
    uint8_t value;
    uint16_t steps[MAX_STEPS];
};

struct op_microcode {
    uint16_t default_steps[MAX_STEPS];
    struct op_flags_alt f_alt[MAX_ALTS];
};

extern const struct op_microcode microcode[] PROGMEM;
extern const uint16_t op_fetch[];

#define     MAKE_MUX_CWORD(MUX_MASK, MPIN_BITS)   ((CTRL_DEFAULT & (~MUX_MASK)) | MPIN_BITS)

#endif /* MICROCODE_H */
