#include "shiftctrl.h"


ShiftCtrl::ShiftCtrl(uint16_t _defaults)
{
    defaults = _defaults;
}

void ShiftCtrl::setup()
{
    shext.setup();
    commit(defaults);
}

void ShiftCtrl::reset()
{
    commit(defaults);
}

void ShiftCtrl::commit(uint16_t c_word)
{
    shext.write16(c_word);
}
