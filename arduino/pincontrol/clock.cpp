#include "clock.h"
#include <Arduino.h>

Clock::Clock(int _pin)
    : pin{_pin}
{
}

void Clock::setup()
{
    /* Default "inactive" position */

    digitalWrite(pin, LOW);
    pinMode(pin, OUTPUT);
}

void Clock::pulse()
{
    digitalWrite(pin, HIGH);
    digitalWrite(pin, LOW);
}