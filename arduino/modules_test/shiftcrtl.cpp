#include "shiftctrl.h"
#include <shiftoutext.h>

ShiftOutExt shext;

ShiftCtrl::ShiftCtrl()
{
    buffer = 0;
    for (unsigned i = 0; i < sizeof(buffer) * 8; ++i)
    {
        pins[i].owner = this;
        pins[i].pin = i;
    }
}

void ShiftCtrl::setup()
{
    shext.setup();
}

void ShiftCtrl::commit()
{
    shext.write16(buffer);
}

ShiftPin::ShiftPin()
{}


ShiftPin &ShiftCtrl::claim(uint8_t _pin, CtrlPin::ActiveLevel _mode)
{
    pins[_pin].mode = _mode;
    return pins[_pin];
}

void ShiftPin::setup()
{
    off(false);
}

void ShiftPin::on(bool autocommit)
{
    if (mode == CtrlPin::ACTIVE_HIGH)
        owner->buffer |= (1 << pin);
    else
        owner->buffer &= ~(1 << pin);
    if (autocommit)
        owner->commit();
}

void ShiftPin::off(bool autocommit)
{
    if (mode == CtrlPin::ACTIVE_HIGH)
        owner->buffer &= ~(1 << pin);
    else
        owner->buffer |= (1 << pin);

    if (autocommit)
        owner->commit();
}

void ShiftPin::set(bool enabled, bool autocommit)
{
    if (enabled)
        on(autocommit);
    else
        off(autocommit);
}
