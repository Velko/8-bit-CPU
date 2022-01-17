#ifdef __AVR__
#define printf(...)
#include "eeprom_ops.h"
#else
#include <stdio.h>
#define eeprom_write(...)
#define eeprom_verify(...)
#define memcpy_P memcpy
#endif

#include <string.h>
#include "microcode.h"
#include "op-defs.h"

void write_cword(FILE *eeprom, uint16_t cword, int rom_idx)
{
    //printf("        %02x\n", cword >> (rom_idx << 3) & 0xFF);
    printf_P(PSTR("        %04x\r\n"), cword);
    fputc(cword >> (rom_idx << 3) & 0xFF, eeprom);
}

void verify_cword(FILE *eeprom, uint16_t cword, int rom_idx)
{
    uint8_t expected = cword >> (rom_idx << 3) & 0xFF;
    uint8_t actual = fgetc(eeprom);
    if (expected != actual)
    {
        printf_P(PSTR("Verification failed!\r\n"));
    }
}


void write_microcode(int rom_idx)
{
    FILE *eeprom = eeprom_open(AT28C64P);

    printf("op f  s cb\n");
    for (int opcode = 0; opcode < NUM_OPS; ++opcode)
    {
        printf ("%02x;\n", opcode);
        for (int flags = 0; flags < (1 << NUM_FLAGS); ++flags)
        {
            int step;
            printf ("   %01x;\n", flags);
            for (step = 0; step < NUM_FETCH_STEPS; ++step)
            {
                printf ("      %d;\n", step);
                write_cword(eeprom, op_fetch[step], rom_idx);
            }

            struct op_microcode instruction;

            memcpy_P(&instruction, &microcode[opcode], sizeof(struct op_microcode));

            const uint16_t *steps = instruction.default_steps - NUM_FETCH_STEPS;

            for (int alt = 0; alt < MAX_ALTS && instruction.f_alt[alt].mask; ++alt)
            {
                if ((flags & instruction.f_alt[alt].mask) == instruction.f_alt[alt].value)
                {
                    steps = instruction.f_alt[alt].steps - NUM_FETCH_STEPS;
                    break;
                }
            }

            for (; step < MAX_STEPS + NUM_FETCH_STEPS && steps[step]; ++step)
            {
                printf ("      %d;\n", step);
                if (steps[step+1] == 0 || step + 1 == MAX_STEPS + NUM_FETCH_STEPS)
                {
                    // add stepcounter reset
                    write_cword(eeprom, steps[step] & (~LPIN_STEPS_RESET_BIT), rom_idx);
                } else {
                    // use as-is
                    write_cword(eeprom, steps[step], rom_idx);
                }
            }

            // fill up with NOPs, in case step counter fails to reset
            for (; step < (1 << NUM_STEP_BITS); ++step)
            {
                printf ("      %d;\n", step);
                write_cword(eeprom, CTRL_DEFAULT, rom_idx);
            }
        }
    }
}


void verify_microcode(int rom_idx)
{
    FILE *eeprom = eeprom_open(AT28C64P);

    printf("op f  s cb\n");
    for (int opcode = 0; opcode < NUM_OPS; ++opcode)
    {
        printf ("%02x;\n", opcode);
        for (int flags = 0; flags < (1 << NUM_FLAGS); ++flags)
        {
            int step;
            printf ("   %01x;\n", flags);
            for (step = 0; step < NUM_FETCH_STEPS; ++step)
            {
                printf ("      %d;\n", step);
                verify_cword(eeprom, op_fetch[step], rom_idx);
            }

            struct op_microcode instruction;

            memcpy_P(&instruction, &microcode[opcode], sizeof(struct op_microcode));

            const uint16_t *steps = instruction.default_steps - NUM_FETCH_STEPS;

            for (int alt = 0; alt < MAX_ALTS && instruction.f_alt[alt].mask; ++alt)
            {
                if ((flags & instruction.f_alt[alt].mask) == instruction.f_alt[alt].value)
                {
                    steps = instruction.f_alt[alt].steps - NUM_FETCH_STEPS;
                    break;
                }
            }

            for (; step < MAX_STEPS + NUM_FETCH_STEPS && steps[step]; ++step)
            {
                printf ("      %d;\n", step);
                if (steps[step+1] == 0 || step + 1 == MAX_STEPS + NUM_FETCH_STEPS)
                {
                    // add stepcounter reset
                    verify_cword(eeprom, steps[step] & (~LPIN_STEPS_RESET_BIT), rom_idx);
                } else {
                    // use as-is
                    verify_cword(eeprom, steps[step], rom_idx);
                }
            }

            // fill up with NOPs, in case step counter fails to reset
            for (; step < (1 << NUM_STEP_BITS); ++step)
            {
                printf ("      %d;\n", step);
                verify_cword(eeprom, CTRL_DEFAULT, rom_idx);
            }
        }
    }
    printf_P(PSTR("Done\r\n"));
}


#ifndef __AVR__
int main()
{
    write_microcode(1);
    return 0;
}
#endif
