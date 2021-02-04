#include <shiftoutext.h>
#include "device_interface.h"
#include "opcodes.h"

DeviceInterface dev;

extern const unsigned char sieve_bin[] PROGMEM;
extern unsigned int sieve_bin_len;

#define NOP_CTRL    0b1111000111100011
#define CLOCK_HLT   0b0000000100000000
#define LOAD_MASK   0b1110000000000000
#define OUT_IDX     0b1100000000000000
#define IRF_BIT     0b0001000000000000
#define MAR_LOAD    0b0101000111100011
#define RAM_WRITE   0b0111000111100011
#define PC_LOAD     0b1011000111100011

void setup()
{
    Serial.begin(115200);
    dev.setup();
    dev.control.write16(NOP_CTRL);
}


void run_program();

void loop()
{
    int cmd = Serial.read();

    if (cmd < 0) return;

    switch (cmd)
    {
    case 'I':
        Serial.println(F("RunControl"));
        break;
    case 'R':
        run_program();
        break;
    default:
        Serial.println(F("Unknown command!"));
        break;
    }
}

char txt_buf[80];

void upload_code()
{
    for (uint8_t addr = 0; addr < sieve_bin_len; ++addr)
    {
        /* Load addr into MAR */
        dev.control.write16(MAR_LOAD);
        dev.mainBus.write(addr);
        dev.clock.pulse();
        dev.inv_clock.pulse();

        /* load program byte into RAM */
        uint8_t data = pgm_read_byte(&sieve_bin[addr]);
        dev.control.write16(RAM_WRITE);
        dev.mainBus.write(data);
        dev.clock.pulse();
        dev.inv_clock.pulse();

        //delay(5);

        if ((addr & 3) == 0)
            Serial.print('.');
    }

    /* release the bus */
    dev.mainBus.set_input();

    Serial.println();
}

void reset_pc()
{
    /* write 0 into PC */
    dev.control.write16(PC_LOAD);
    dev.mainBus.write(0);
    dev.clock.pulse();
    dev.inv_clock.pulse();

    /* release the bus */
    dev.mainBus.set_input();
}

uint8_t fetch_instruction()
{
    dev.control.write16(fetch[0]);
    dev.clock.pulse();
    dev.inv_clock.pulse();

    /* combine last fetch step with IRFETCH enable */
    dev.control.write16(fetch[1] ^ IRF_BIT);
    dev.clock.pulse();
    dev.inv_clock.pulse();

    /* write it 2 times, to get the instruction from IR */
    dev.control.write16(NOP_CTRL);
    uint8_t opcode = dev.control.write16(NOP_CTRL);

    return opcode;
}

void execute_steps()
{
    for(;;)
    {
        uint8_t opcode = fetch_instruction();
        uint8_t flags = dev.flagsBus.read();

        //delay(1);
        //sprintf(txt_buf, "Opcode: %02x", opcode);
        //Serial.println(txt_buf);

        struct opcode instruction;

        memcpy_P(&instruction, &opcodes[opcode], sizeof(struct opcode));

        uint16_t *steps = instruction.default_steps;

        /* currently only single flags_alt is allowed, this makes things simpler */
        if (instruction.f_alt[0].mask)
        {
            if ((flags & instruction.f_alt[0].mask) == instruction.f_alt[0].value)
                steps = instruction.f_alt[0].steps;
        }

        for (uint8_t i = 0; i < MAX_STEPS && steps[i]; ++i)
        {
            //sprintf(txt_buf, "Step: %04x", steps[i]);
            //Serial.println(txt_buf);
            dev.control.write16(steps[i]);
            dev.clock.pulse();

            /* special handling to intercept output */
            if ((steps[i] & LOAD_MASK) == OUT_IDX)
            {
                uint8_t out_val = dev.mainBus.read();
                sprintf(txt_buf, "%d", out_val);
                Serial.println(txt_buf);
            }

            dev.inv_clock.pulse();

            if ((steps[i] & CLOCK_HLT) == 0)
            {
                Serial.println("Halted");
                return;
            }
        }
    }
}

void run_program()
{
    upload_code();
    for (;;) {
        reset_pc();
        execute_steps();
    }
}