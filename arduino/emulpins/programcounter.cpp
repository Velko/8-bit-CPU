#include "devices.h"
#include "op-defs.h"


ProgramCounter PC(MPIN_PC_OUT_BITS, MPIN_PC_LOAD_BITS);
ProgramCounter LR(MPIN_LR_OUT_BITS, MPIN_LR_LOAD_BITS);

ProgramCounter::ProgramCounter(cword_t out_cnt, cword_t load)
    : _out_cnt(MUX_ADDROUT_MASK, out_cnt),
      _load(MUX_ADDRLOAD_MASK, load)
{}


void ProgramCounter::control_updated()
{
    if (_out_cnt.is_enabled(_control)) {
        address_bus = secondary;
    }
}

void ProgramCounter::clock_pulse()
{
    if (_out_cnt.is_enabled(_control))
        ++primary;
    if (_load.is_enabled(_control))
        primary = address_bus;
}

void ProgramCounter::clock_inverted()
{
    secondary = primary;
}
