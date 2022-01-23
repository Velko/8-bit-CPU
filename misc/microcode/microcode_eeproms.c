#include <stdio.h>

#include <string.h>
#include "microcode.h"
#include "op-defs.h"

void write_cword(FILE *eeprom, cword_t cword, int rom_idx)
{
    fputc(cword >> (rom_idx << 3) & 0xFF, eeprom);
}

void write_microcode(FILE *eeprom, int rom_idx)
{
    for (int opcode = 0; opcode < NUM_OPS; ++opcode)
    {
        for (int flags = 0; flags < (1 << NUM_FLAGS); ++flags)
        {
            int step;
            for (step = 0; step < NUM_FETCH_STEPS; ++step)
            {
                write_cword(eeprom, op_fetch[step], rom_idx);
            }

            const struct op_microcode *instruction = microcode + opcode;

            const cword_t *steps = instruction->default_steps - NUM_FETCH_STEPS;

            for (int alt = 0; alt < MAX_ALTS && instruction->f_alt[alt].mask; ++alt)
            {
                if ((flags & instruction->f_alt[alt].mask) == instruction->f_alt[alt].value)
                {
                    steps = instruction->f_alt[alt].steps - NUM_FETCH_STEPS;
                    break;
                }
            }

            for (; step < MAX_STEPS + NUM_FETCH_STEPS && steps[step]; ++step)
            {
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
                write_cword(eeprom, CTRL_DEFAULT, rom_idx);
            }
        }
    }
}

int main()
{
    FILE *rom0 = fopen("control0.bin", "wb");
    write_microcode(rom0, 0);
    fclose(rom0);

    FILE *rom1 = fopen("control1.bin", "wb");
    write_microcode(rom1, 1);
    fclose(rom1);

    FILE *rom2 = fopen("control2.bin", "wb");
    write_microcode(rom2, 2);
    fclose(rom2);

    FILE *rom3 = fopen("control3.bin", "wb");
    write_microcode(rom3, 3);
    fclose(rom3);

    return 0;
}
