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
    digitalWrite(PIN_COUNT, HIGH);
    delay(1);
    clock.pulse();
    digitalWrite(PIN_COUNT, LOW);
}
