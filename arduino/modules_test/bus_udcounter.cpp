#include "bus_udcounter.h"

#define PIN_UP_DOWN   SDA

void UpDownCounter::setup()
{
    Counter::setup();

    digitalWrite(PIN_UP_DOWN, HIGH);
    pinMode(PIN_UP_DOWN, OUTPUT);
}

void UpDownCounter::MoveNext()
{
    digitalWrite(PIN_UP_DOWN, HIGH);
    Counter::MoveNext();
}

void UpDownCounter::MovePrev()
{
    digitalWrite(PIN_UP_DOWN, LOW);
    Counter::MoveNext();
}
