#include <Arduino.h>
#include "iobus.h"

IOBus::IOBus(uint8_t p0, uint8_t p1, uint8_t p2, uint8_t p3, uint8_t p4, uint8_t p5, uint8_t p6, uint8_t p7)
    : pins({ p0, p1, p2, p3, p4, p5, p6, p7})
{
}

void IOBus::set_input()
{
    for (int i = 0; i < IOBus::WIDTH; ++i)
    {
        pinMode(pins[i], INPUT_PULLUP);
    }
}

uint8_t IOBus::read()
{
    uint8_t res = 0;

    for (int i = IOBus::WIDTH - 1; i >= 0 ; --i)
    {
        res <<= 1;
        res |= digitalRead(pins[i]) == HIGH ? 1 : 0;
    }

    return res;
}

void IOBus::write(uint8_t value)
{
    for (int i = 0; i < IOBus::WIDTH ; ++i)
    {
        pinMode(pins[i], OUTPUT);
        digitalWrite(pins[i], value & 1 ? HIGH : LOW);

        value >>= 1;
    }
}