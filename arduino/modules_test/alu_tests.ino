#include "bus_alu.h"


ALU alu;

void alu_tests()
{
    alu.setup();
    alu_add_bytes();
    alu_sub_bytes();
}

void alu_add_bytes()
{
    Serial.print(F("Add bytes"));
    for (int b = 0; b < 256; ++b)
    {
        if ((b % 8) == 0)
            Serial.print('.');

        for (int a = 0; a < 256; ++a)
        {
            uint8_t res = alu.add(a, b);

            uint8_t expected = a + b;
            if (res != expected)
            {
                Serial.print(a);
                Serial.print(F(" + "));
                Serial.print(b);
                Serial.print(F(" = "));
                Serial.print(expected);
                Serial.print(F(" but received "));
                Serial.println(res);
                return;
            }
        }
    }
    Serial.println(F("OK"));
}

void alu_sub_bytes()
{
    Serial.print(F("Subtract bytes"));
    for (int b = 0; b < 256; ++b)
    {
        if ((b % 8) == 0)
            Serial.print('.');

        for (int a = 0; a < 256; ++a)
        {
            int8_t res = alu.sub(a, b);

            int8_t expected = a - b;
            if (res != expected)
            {
                Serial.print(a);
                Serial.print(F(" - "));
                Serial.print(b);
                Serial.print(F(" = "));
                Serial.print(expected);
                Serial.print(F(" but received "));
                Serial.println(res);
                return;
            }
        }
    }
    Serial.println(F("OK"));
}