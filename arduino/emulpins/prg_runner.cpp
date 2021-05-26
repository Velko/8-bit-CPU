#include <Arduino.h>
#include "device_interface.h"
#include "microcode.h"
#include "op-defs.h"
#include "devices.h"

extern DeviceInterface dev;

char txt_buf[80];

void reset_pc()
{
    /* write 0 into PC */
    dev.control.write32(MAKE_MUX_CWORD(MUX_LOAD_MASK, MPIN_PC_LOAD_BITS));
    dev.mainBus.write(0);
    dev.clock.pulse();
    dev.inv_clock.pulse();

    /* release the bus */
    dev.mainBus.set_input();
}

uint8_t fetch_instruction()
{
    dev.control.write32(op_fetch[0]);
    dev.clock.pulse();
    dev.inv_clock.pulse();

    /* combine last fetch step with IRFETCH enable */
    dev.control.write32(op_fetch[1]);
    dev.clock.pulse();
    dev.inv_clock.pulse();

    return IR.read_tap();
}

void execute_steps()
{
    for(;;)
    {
        uint8_t opcode = fetch_instruction();
        uint8_t flags = dev.flagsBus.read();

        delay(1);

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
                sprintf(txt_buf, "%d", out_val);
                Serial.println(txt_buf);
                delay(250);
            }

            /* special handling to intercept character output */
            if ((steps[i] & MUX_LOAD_MASK) ==  MPIN_COUT_LOAD_BITS)
            {
                uint8_t out_val = dev.mainBus.read();
                sprintf(txt_buf, "%c", out_val);
                Serial.print(txt_buf);
                delay(5);
            }

            dev.inv_clock.pulse();

            if ((steps[i] & LPIN_CLOCK_HALT_BIT) == 0)
            {
                Serial.println("Halted");
                return;
            }
        }
    }
}

void run_program()
{
    reset_pc();
    execute_steps();
}
