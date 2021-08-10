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

uint16_t uc_output_address;

void write_cword(cword_t cword, int rom_idx)
{
    //printf("        %02x\n", cword >> (rom_idx << 3) & 0xFF);
    printf("        %04x\n", cword);
    eeprom_write(uc_output_address, cword >> (rom_idx << 3) & 0xFF);
    ++uc_output_address;
}

void verify_cword(cword_t cword, int rom_idx)
{
    eeprom_verify(uc_output_address, cword >> (rom_idx << 3) & 0xFF);
    ++uc_output_address;
}


void write_microcode(int rom_idx)
{
    uc_output_address = 0;
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
                write_cword(op_fetch[step], rom_idx);
            }

            struct op_microcode instruction;

            memcpy_P(&instruction, &microcode[opcode], sizeof(struct op_microcode));

            const cword_t *steps = instruction.default_steps - NUM_FETCH_STEPS;

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
                    write_cword(steps[step] & (~LPIN_STEPS_RESET_BIT), rom_idx);
                } else {
                    // use as-is
                    write_cword(steps[step], rom_idx);
                }
            }

            // fill up with NOPs, in case step counter fails to reset
            for (; step < (1 << NUM_STEP_BITS); ++step)
            {
                printf ("      %d;\n", step);
                write_cword(CTRL_DEFAULT, rom_idx);
            }
        }
    }
}


void verify_microcode(int rom_idx)
{
    uc_output_address = 0;
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
                write_cword(op_fetch[step], rom_idx);
            }

            struct op_microcode instruction;

            memcpy_P(&instruction, &microcode[opcode], sizeof(struct op_microcode));

            const cword_t *steps = instruction.default_steps - NUM_FETCH_STEPS;

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
                    write_cword(steps[step] & (~LPIN_STEPS_RESET_BIT), rom_idx);
                } else {
                    // use as-is
                    write_cword(steps[step], rom_idx);
                }
            }

            // fill up with NOPs, in case step counter fails to reset
            for (; step < (1 << NUM_STEP_BITS); ++step)
            {
                printf ("      %d;\n", step);
                verify_cword(CTRL_DEFAULT, rom_idx);
            }
        }
    }
}


#ifndef __AVR__
int main()
{
    write_microcode(1);
    return 0;
}
#endif
