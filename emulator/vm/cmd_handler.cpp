#include "serial_host.h"
#define F(X)        (X)

#include "op-defs.h"
#include "cpu.h"

CPU *cpu;

void run_program();

void setup()
{
    Serial.begin(115200);
    cpu = new CPU();
    cpu->off();
    cpu->reset();
}


void loop()
{
    int cmd = Serial.read();

    if (cmd < 0) return;

    uint32_t val = 0;

    switch (cmd)
    {
    case 'I':
        Serial.println(F("VerilogVM"));
        break;

    case 'B':
        val = Serial.parseInt();
        cpu->main_bus_write(val);
        break;

    case 'b':
        cpu->main_bus_set_input();
        val = cpu->main_bus;
        Serial.println(val);
        break;

    case 'A':
        val = Serial.parseInt();
//        dev.addressBus.write(val);
        break;

    case 'a':
//        dev.addressBus.set_input();
//        val = dev.addressBus.read();
        Serial.println(val);
        break;

    case 's':
        val = cpu->fout;
        Serial.println(val);
        break;

    case 'f':
        cpu->main_bus_set_input();
        break;

    case 'O':
        val = Serial.parseInt();
        cpu->main_bus_set_input();
        cpu->set_control_word(val);
        break;

    case 'M':
        val = Serial.parseInt();
        cpu->set_control_word(val);
        break;

    case 'N':
        // NOP
        break;

    case 'c':
        cpu->clk_pulse();
        break;

    case 'C':
        cpu->iclk_pulse();
        break;

    case 'T':
        cpu->clock_tick();
        break;

    case 'r':
        val = Serial.parseInt();
//        Serial.println(Processor.current_opcode());
        break;

    case 'R':
//        run_program();
        break;

    default:
        Serial.println(F("Unknown command!"));
        break;
    }
}
