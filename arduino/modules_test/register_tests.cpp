#include <Arduino.h>
#include "bus_register.h"
#include "register_tests.h"


void register_demo()
{
    Register reg(DeviceInterface::instance);
    reg.setup();

    for (;;)
    {
        for (int i = 1; i < 256; i <<= 1)
        {
            Serial.print(i);
            Serial.print(" ");

            reg.write_check(i);
            delay(250);

            uint8_t readback = reg.read();
            Serial.print(readback);
            if (readback == i)
              Serial.println("   OK");
            else
              Serial.println("   ERR");
        }
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
