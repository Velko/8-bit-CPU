#include <Arduino.h>
#include "iobus.h"

IOBus::IOBus(std::initializer_list<uint8_t> _pins)
{
    this->size = _pins.size();
    if (this->size > IOBus::MAX_SIZE) this->size = IOBus::MAX_SIZE;

    auto p = _pins.begin();
    for (int i = 0; i < this->size; ++i, ++p)
    {
        pins[i] = *p;
    }
}

void IOBus::set_input()
{
    for (int i = 0; i < this->size; ++i)
    {
        pinMode(pins[i], INPUT_PULLUP);
    }
}

uint8_t IOBus::read()
{
    uint8_t res = 0;

    for (int i = this->size - 1; i >= 0 ; --i)
    {
        res <<= 1;
        res |= digitalRead(pins[i]) == HIGH ? 1 : 0;
    }

    return res;
}

void IOBus::write(uint8_t value)
{
    for (int i = 0; i < this->size; ++i)
    {
        pinMode(pins[i], OUTPUT);
        digitalWrite(pins[i], value & 1 ? HIGH : LOW);

        value >>= 1;
    }
}