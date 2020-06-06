#include "bus_counter.h"


#include <Arduino.h>

#define PIN_COUNT       SCL


void Counter::setup()
{
    Register::setup();

    digitalWrite(PIN_COUNT, LOW);
    pinMode(PIN_COUNT, OUTPUT);
}

void Counter::MoveNext()
{
    advance(true);
}

void Counter::advance(bool active_high)
{
    digitalWrite(PIN_COUNT, active_high ? HIGH : LOW);
    delayMicroseconds(10);
    clock.pulse();
    digitalWrite(PIN_COUNT, active_high ? LOW : HIGH);
}