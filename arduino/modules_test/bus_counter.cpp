#include "bus_counter.h"


#include <Arduino.h>

#define PIN_COUNT       SCL

Counter::Counter()
    : pin_c_enable{PIN_COUNT, CtrlPin::ACTIVE_HIGH}
{
}

Counter::Counter(CtrlPin::ActiveLevel enable_mode)
    : pin_c_enable{PIN_COUNT, enable_mode}
{
}

void Counter::setup()
{
    Register::setup();
    pin_c_enable.setup();
}

void Counter::MoveNext()
{
    pin_c_enable.on();
    clock.pulse();
    pin_c_enable.off();

    // additional pulses to see if CE
    // really works
    clock.pulse();
    clock.pulse();
}
