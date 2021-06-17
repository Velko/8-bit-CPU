
#include "devices.h"
#include "op-defs.h"

uint8_t flags_bus;

FlagsReg Flags(MPIN_F_OUT_BITS, MPIN_F_LOAD_BITS, LPIN_F_CALC_BIT);

FlagsReg::FlagsReg(cword_t out, cword_t load, cword_t calc)
    : _out(MUX_OUT_MASK, out),
      _load(MUX_LOAD_MASK, load),
      _calc(calc, 0)
{}

void FlagsReg::clock_pulse()
{
    if (_load.is_enabled(_control))
    {
        latched_primary = main_bus & 0x0F;
    }
    else if (_calc.is_enabled(_control))
    {
        latched_primary = flags_bus & (FLAG_C | FLAG_V);
        if (main_bus == 0)
            latched_primary |= FLAG_Z;
        if ((main_bus & 0x80) != 0)
            latched_primary |= FLAG_N;
    }
}

void FlagsReg::clock_inverted()
{
    latched_secondary = latched_primary;
}

uint8_t FlagsReg::read_tap()
{
    return latched_secondary;
}
void FlagsReg::control_updated()
{
    if (_out.is_enabled(_control))
        main_bus = latched_primary;
}