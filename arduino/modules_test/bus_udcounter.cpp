#include "bus_udcounter.h"
#include <Arduino.h>

#define PIN_UP_DOWN   3

UpDownCounter::UpDownCounter(DeviceInterface &_dev)
    : Counter(_dev, CtrlPin::ACTIVE_LOW),
      pin_down{PIN_UP_DOWN, CtrlPin::ACTIVE_HIGH}
{
}

void UpDownCounter::setup()
{
    Counter::setup();
    pin_down.setup();
}

void UpDownCounter::MoveNext()
{
    pin_down.off();
    Counter::MoveNext();
}

void UpDownCounter::MovePrev()
{
    pin_down.on();
    Counter::MoveNext();
}
