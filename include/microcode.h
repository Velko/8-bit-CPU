#ifndef MICROCODE_H
#define MICROCODE_H

#include <stdint.h>

#ifdef __AVR__
#include <avr/pgmspace.h>
#else
#define PROGMEM
#endif

/* "Compressed" description */
#define MAX_STEPS       6
#define MAX_ALTS        1

/* Hardware config */
#define NUM_FLAGS       4
#define NUM_STEP_BITS   3

typedef uint32_t cword_t;

struct op_flags_alt {
    uint8_t mask;
    uint8_t value;
    cword_t steps[MAX_STEPS];
};

struct op_microcode {
    cword_t default_steps[MAX_STEPS];
    struct op_flags_alt f_alt[MAX_ALTS];
};

extern const struct op_microcode microcode[] PROGMEM;
extern const cword_t op_fetch[];

#define     APPLY_MUX(TARGET, MASK, MBITS)      TARGET = (TARGET & (~MASK)) | MBITS
#define     APPLY_HPIN(TARGET, HBITS)      TARGET = TARGET | HBITS
#define     APPLY_LPIN(TARGET, LBITS)      TARGET = TARGET & (~LBITS)



#endif /* MICROCODE_H */
