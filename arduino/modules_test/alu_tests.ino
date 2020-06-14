#include "bus_alu.h"


ALU alu;

void alu_tests()
{
    alu.setup();
    alu_add_bytes();
    alu_sub_bytes();
    alu_add_16bit();
    alu_sub_16bit();
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

void alu_add_16bit()
{
    Serial.print(F("Add 16bit"));

    /* It will take too long to perform a run with all possible
       16-bit values - 4,294,967,296 operations will take couple
       of months, but we can speed things up ~250,000 times by
       choosing seemingly random numbers. We still check ~17,000
       combinations. If none of them fails, we're most likely good.

       This is to check if add + adc works as expected.
    */
    for (long b = 0; b < 0x10000; b += 503)
    {
        if ((b % 8) == 0)
            Serial.print('.');

        for (long a = 0; a < 0x10000; a += 499)
        {
            uint8_t resb[2];
            resb[0] = alu.add(a, b);
            resb[1] = alu.add(a >> 8, b >> 8, true);
            uint16_t res = *((uint16_t *)resb);

            uint16_t expected = a + b;
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

void alu_sub_16bit()
{
    Serial.print(F("Subtract 16bit"));

    /* Same as with add_16bit - just do quick checks for sub + sbc */
    for (long b = 0; b < 0x10000; b += 503)
    {
        if ((b % 8) == 0)
            Serial.print('.');

        for (long a = 0; a < 0x10000; a += 499)
        {
            /* need to be careful with combination of
               the result bytes, as C is "helpfully"
               sign-extending those */
            int8_t resb[2];
            resb[0] = alu.sub(a, b);
            resb[1] = alu.sub(a >> 8, b >> 8, true);
            int16_t res = *((int16_t *)resb);

            int16_t expected = a - b;
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
