#include "shiftctrl.h"


ShiftCtrl::ShiftCtrl(uint8_t _init)
{
    buffer = _init;
    init = _init;
}

void ShiftCtrl::setup()
{
    shext.setup();
    commit();
}

void ShiftCtrl::reset()
{
    buffer = init;
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
