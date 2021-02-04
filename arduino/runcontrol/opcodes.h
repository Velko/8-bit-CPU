#ifndef OPCODES_H
#define OPCODES_H

#include <stdint.h>
#include <avr/pgmspace.h>

#define MAX_STEPS       4
#define MAX_ALTS        1

struct flags_alt {
    uint8_t mask;
    uint8_t value;
    uint16_t steps[MAX_STEPS];
};

struct opcode {
    uint16_t default_steps[MAX_STEPS];
    struct flags_alt f_alt[MAX_ALTS];
};

extern const struct opcode opcodes[] PROGMEM;
extern const uint16_t fetch[];

#endif /* OPCODES_H */