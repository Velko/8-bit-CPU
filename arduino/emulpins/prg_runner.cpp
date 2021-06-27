#ifdef __AVR__

#include <Arduino.h>

#else

#include <cstring>
#include "serial_host.h"
#define memcpy_P    memcpy

#endif

#include "device_interface.h"
#include "microcode.h"
#include "op-defs.h"
#include "devices.h"

extern DeviceInterface dev;

char txt_buf[80];

uint8_t fetch_instruction()
{
    dev.control.write32(op_fetch[0]);
    dev.clock.pulse();
    dev.inv_clock.pulse();

    return Processor.current_opcode();
}

void execute_steps()
{
    for(;;)
    {
        uint8_t opcode = fetch_instruction();
        uint8_t flags = dev.flagsBus.read();

        struct op_microcode instruction;

        memcpy_P(&instruction, &microcode[opcode], sizeof(struct op_microcode));

        uint32_t *steps = instruction.default_steps;

        /* currently only single flags_alt is allowed, this makes things simpler */
        if (instruction.f_alt[0].mask)
        {
            if ((flags & instruction.f_alt[0].mask) == instruction.f_alt[0].value)
                steps = instruction.f_alt[0].steps;
        }

        for (uint8_t i = 0; i < MAX_STEPS && steps[i]; ++i)
        {
            dev.control.write32(steps[i]);
            dev.clock.pulse();

            /* special handling to intercept output */
            if ((steps[i] & MUX_LOAD_MASK) ==  MPIN_OUT_LOAD_BITS)
            {
                uint8_t out_val = dev.mainBus.read();
                sprintf(txt_buf, "#IOUT#%d", out_val);
                Serial.println(txt_buf);
            }

            /* special handling to intercept character output */
            if ((steps[i] & MUX_LOAD_MASK) ==  MPIN_COUT_LOAD_BITS)
            {
                uint8_t out_val = dev.mainBus.read();
                sprintf(txt_buf, "#COUT#%d", out_val);
                Serial.println(txt_buf);
            }

            dev.inv_clock.pulse();

            if ((steps[i] & LPIN_CLOCK_HALT_BIT) == 0)
            {
                Serial.println("#HLT");
                return;
            }

            if ((steps[i] & HPIN_CLOCK_BRK_BIT) != 0)
            {
                Serial.println("#BRK");
                return;
            }
        }
    }
}

void run_program()
{
    execute_steps();
}
