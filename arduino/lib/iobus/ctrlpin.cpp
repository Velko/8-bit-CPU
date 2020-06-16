#include "ctrlpin.h"
#include <Arduino.h>

CtrlPin::CtrlPin(uint8_t _pin, ActiveLevel _mode)
{
    pin = _pin;
    mode = _mode;
}

void CtrlPin::setup()
{
    pinMode(pin, OUTPUT);
    off();
}

void CtrlPin::on()
{
    digitalWrite(pin, mode == ACTIVE_HIGH ? HIGH : LOW);
}

void CtrlPin::off()
{
    digitalWrite(pin, mode == ACTIVE_HIGH ? LOW : HIGH);
}

void CtrlPin::set(bool enabled)
{
    if (enabled)
        on();
    else
        off();
}