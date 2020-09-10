#include <Arduino.h>
#include "bus_register.h"
#include "register_tests.h"

void print_bits(uint8_t bits)
{
    char buff[9];

    for (int i = 0; i < 8; ++i, bits <<= 1)
    {
        buff[i] = (bits & 0x80) ? '*' : '.';
    }
    buff[8] = 0;

    Serial.print(buff);
}


void register_demo_step(Register &reg, uint8_t i);

void register_demo()
{
    Register reg(DeviceInterface::instance);
    reg.setup();

    for (;;)
    {
        register_demo_cycle(reg, "");
    }
}

void register_demo_cycle(Register &reg, const char *label)
{
    Serial.println(label);

    for (int i = 1; i < 256; i <<= 1)
    {
        register_demo_step(reg, i);
    }

    delay(250);

    for (int i = 128; i > 0; i >>= 1)
    {
        register_demo_step(reg, i);
    }
}

void register_demo_step(Register &reg, uint8_t i)
{
    print_bits(i);
    reg.write_check(i);
    delay(250);

    uint8_t readback = reg.read();
    if (readback == i)
        Serial.println("   OK");
    else {
        Serial.println("   ERR");
        print_bits(readback);
        Serial.println();
    }
}


void register_load(int val)
{
    Register reg(DeviceInterface::instance);
    reg.setup();
    reg.write_check(val);
}

void register_tests()
{
    Register reg(DeviceInterface::instance);
    reg.setup();

    reg_load_store_output(&reg, 1000, "REG");
}

void reg_load_store_output(Register *r, int repeats, const char *label)
{
    r->setup();

    Serial.print(F("Load-store-output "));
    Serial.print(label);
    for (int pass = 0; pass < repeats; ++pass)
    {
        if (pass % 50 == 0)
            Serial.print('.');
        for (int i = 1; i < 256; i <<= 1)
        {
            r->write_check(i);
            uint8_t readback = r->read();

            if (readback != i)
            {
                Serial.print(F("ERR "));
                Serial.println(i);
                return;
            }
        }
    }
    Serial.println(F("OK"));
}
