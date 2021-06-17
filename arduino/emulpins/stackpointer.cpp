#include "devices.h"
#include "op-defs.h"


StackPointer r_SP(MPIN_SP_OUT_BITS, MPIN_SP_LOAD_BITS, LPIN_SP_INC_BIT, LPIN_SP_DEC_BIT);

StackPointer::StackPointer(cword_t out, cword_t load, cword_t inc, cword_t dec)
    : _out(MUX_ADDROUT_MASK, out),
      _load(MUX_ADDRLOAD_MASK, load),
      _inc(LPIN_SP_INC_BIT, 0),
      _dec(LPIN_SP_DEC_BIT, 0)
{}

void StackPointer::control_updated()
{
    if (_out.is_enabled(_control)) {
        address_bus = val;
    }
}

void StackPointer::clock_pulse()
{
    if (_inc.is_enabled(_control))
        ++val;
    if (_dec.is_enabled(_control))
        --val;
    if (_load.is_enabled(_control))
        val = address_bus;
}
