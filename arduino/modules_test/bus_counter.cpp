#include "bus_counter.h"


#include <Arduino.h>

#define PIN_COUNT       SCL


void Counter::setup()
{
    Register::setup();

    set_count_enable(false);
    pinMode(PIN_COUNT, OUTPUT);
}

void Counter::MoveNext()
{
    set_count_enable(true);
    clock.pulse();
    set_count_enable(false);

    // additional pulses to see if CE
    // really works
    clock.pulse();
    clock.pulse();
}

void Counter::set_count_enable(bool enabled)
{
    digitalWrite(PIN_COUNT, enabled ? HIGH : LOW);
}