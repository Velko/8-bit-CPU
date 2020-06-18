#include "shiftctrl.h"
#include <shiftoutext.h>

ShiftOutExt shext;

void ShiftCtrl::setup()
{
    buffer = 0;
    shext.setup();
}

void ShiftCtrl::commit()
{
    shext.write8(buffer);
}

uint8_t ShiftCtrl::buffer;

ShiftPin::ShiftPin(uint8_t _pin, CtrlPin::ActiveLevel _mode)
{
    pin = _pin;
    mode = _mode;
}

void ShiftPin::setup()
{
    off(false);
}

void ShiftPin::on(bool autocommit)
{
    if (mode == CtrlPin::ACTIVE_HIGH)
        ShiftCtrl::buffer |= (1 << pin);
    else
        ShiftCtrl::buffer &= ~(1 << pin);
    if (autocommit)
        ShiftCtrl::commit();
}

void ShiftPin::off(bool autocommit)
{
    if (mode == CtrlPin::ACTIVE_HIGH)
        ShiftCtrl::buffer &= ~(1 << pin);
    else
        ShiftCtrl::buffer |= (1 << pin);

    if (autocommit)
        ShiftCtrl::commit();
}

void ShiftPin::set(bool enabled, bool autocommit)
{
    if (enabled)
        on();
    else
        off();

    if (autocommit)
        ShiftCtrl::commit();
}
