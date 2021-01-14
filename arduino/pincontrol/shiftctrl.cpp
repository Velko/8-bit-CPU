#include "shiftctrl.h"
#include <shiftoutext.h>

ShiftOutExt shext;

ShiftCtrl::ShiftCtrl(uint8_t init)
{
    buffer = init;
}

void ShiftCtrl::setup()
{
    shext.setup();
    commit();
}

void ShiftCtrl::commit()
{
    shext.write8(buffer);
}

void ShiftCtrl::set(uint8_t pin)
{
    buffer |= (1 << pin);
}

void ShiftCtrl::clear(uint8_t pin)
{
    buffer &= ~(1 << pin);
}
