#include "clock.h"
#include <Arduino.h>

#define PIN_CLK    11

void Clock::setup()
{
    /* Default "inactive" position */

    digitalWrite(PIN_CLK, LOW);
    pinMode(PIN_CLK, OUTPUT);
}

void Clock::pulse()
{
    digitalWrite(PIN_CLK, HIGH);
    delay(100);
    digitalWrite(PIN_CLK, LOW);
}