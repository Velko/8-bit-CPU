#include "outpin.h"

template <typename LEVEL>
OutPin<LEVEL>::OutPin(uint8_t _pin)
{
    pin = _pin;
}

template <typename LEVEL>
void OutPin<LEVEL>::setup()
{
    off();
    pinMode(pin, OUTPUT);
}

template <typename LEVEL>
void OutPin<LEVEL>::on()
{
    digitalWrite(pin, LEVEL::ON);
}

template <typename LEVEL>
void OutPin<LEVEL>::off()
{
    digitalWrite(pin, LEVEL::OFF);
}

template <typename LEVEL>
void OutPin<LEVEL>::set(bool enabled)
{
    if (enabled)
        on();
    else
        off();
}

template class OutPin<OutPinModeActiveHigh>;
template class OutPin<OutPinModeActiveLow>;