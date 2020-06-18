#include "bus_alu.h"
#include "alu_ref.h"

/*
    To verify if ALU sets flags as expected, we're comparing them to flags that are set by
    AVR microcontroller. The flags layout may be different, but same instructions with same
    arguments should produce same results (including the flags).

    But to capture the tiniest details, we should dive into assembly language. I'm not that
    familiar with AVR assembly to write those functions from scratch, but there is an easier
    path: write it in C and use compiler to generate the assembly. Adding some modifications
    in existing file is much easier.

    So there is alu_ref.ctmpl file that is used to generate the "template". Commands required
    to translate that are located in make_asm.sh script. After that alu_ref.S can be modified
    to get desired results. But keep in mind that re-running the script will "reset" the file
    back to "defaults". Luckily - there's source control (Git) that can help with that.
*/


#define AVR_FLAG_C      0b0001
#define AVR_FLAG_Z      0b0010
#define AVR_FLAG_N      0b0100
#define AVR_FLAG_V      0b1000

#define ALU_FLAG_Z      0b0001
#define ALU_FLAG_V      0b0010
#define ALU_FLAG_N      0b0100
#define ALU_FLAG_C      0b1000

#define FLAG_IS_SET(val, flag)     ((val & flag)!=0)

ALU alu;

void alu_tests()
{
    alu.setup();
    alu_add_bytes();
    alu_add_bytes_cset();
    alu_sub_bytes();
    alu_sub_bytes_cset();
    alu_add_16bit();
    alu_sub_16bit();
}

uint8_t flags_avr2alu(uint8_t avr_flags)
{
    uint8_t alu_flags = 0;

    if (FLAG_IS_SET(avr_flags, AVR_FLAG_C)) alu_flags |= ALU_FLAG_C;
    if (FLAG_IS_SET(avr_flags, AVR_FLAG_Z)) alu_flags |= ALU_FLAG_Z;
    if (FLAG_IS_SET(avr_flags, AVR_FLAG_N)) alu_flags |= ALU_FLAG_N;
    if (FLAG_IS_SET(avr_flags, AVR_FLAG_V)) alu_flags |= ALU_FLAG_V;

    return alu_flags;
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
            uint8_t flags = alu.read_flags();

            uint8_t expected = a + b;
            uint8_t expected_flags = flags_avr2alu(flags_of_add8(a, b));

            if (res != expected || flags != expected_flags)
            {
                char line[80];

                sprintf_P(line, PSTR("%d + %d = %d but received %d flags - expect %x real %x"), a, b, expected, res, expected_flags, flags);
                Serial.println(line);
                return;
            }
        }
    }
    Serial.println(F("OK"));
}

void alu_add_bytes_cset()
{
    Serial.print(F("Add bytes (C)"));
    for (int b = 0; b < 256; ++b)
    {
        if ((b % 8) == 0)
            Serial.print('.');

        for (int a = 0; a < 256; ++a)
        {
            alu.add(255, 1); // an easy (but sub-optimal) way to set C bit
            uint8_t res = alu.add(a, b, true);
            uint8_t flags = alu.read_flags();

            uint8_t expected = add8_set_carry(a, b);
            uint8_t expected_flags = flags_avr2alu(flags_of_add8_with_c(a, b));

            if (res != expected || flags != expected_flags)
            {
                char line[80];

                sprintf_P(line, PSTR("%d + %d + 1 = %d but received %d flags - expect %x real %x"), a, b, expected, res, expected_flags, flags);
                Serial.println(line);
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
            uint8_t flags = alu.read_flags();

            int8_t expected = a - b;
            uint8_t expected_flags = flags_avr2alu(flags_of_sub8(a, b));

            if (res != expected || flags != expected_flags)
            {
                char line[80];

                sprintf_P(line, PSTR("%d - %d = %d but received %d flags - expect %x real %x"), a, b, expected, res, expected_flags, flags);
                Serial.println(line);
                return;
            }
        }
    }
    Serial.println(F("OK"));
}

void alu_sub_bytes_cset()
{
    Serial.print(F("Subtract bytes (C)"));
    for (int b = 0; b < 256; ++b)
    {
        if ((b % 8) == 0)
            Serial.print('.');

        for (int a = 0; a < 256; ++a)
        {
            alu.add(255, 1); // an easy (but sub-optimal) way to set C bit
            int8_t res = alu.sub(a, b, true);
            uint8_t flags = alu.read_flags();

            int8_t expected = sub8_set_carry(a, b);
            uint8_t expected_flags = flags_avr2alu(flags_of_sub8_with_c(a, b));

            if (res != expected || flags != expected_flags)
            {
                char line[80];

                sprintf_P(line, PSTR("%d - %d - 1 = %d but received %d flags - expect %x real %x"), a, b, expected, res, expected_flags, flags);
                Serial.println(line);
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
                char line[80];
                sprintf_P(line, PSTR("%d + %d = %d but received %d"), a , b, expected, res);
                Serial.println(line);
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
                char line[80];
                sprintf_P(line, PSTR("%d - %d = %d but received %d"), a , b, expected, res);
                Serial.println(line);
                return;
            }
        }
    }
    Serial.println(F("OK"));
}
