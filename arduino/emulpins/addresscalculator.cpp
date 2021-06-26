#include "devices.h"
#include "op-defs.h"

AddressCalculator::AddressCalculator(cword_t out, cword_t load)
    : _out(MUX_ADDROUT_MASK, out),
      _load(MUX_ADDRLOAD_MASK, load)
{}

void AddressCalculator::control_updated()
{
    if (_out.is_enabled(_control))
        address_bus = val;
}

void AddressCalculator::clock_pulse()
{
    if (_load.is_enabled(_control)) {
        int8_t offset = main_bus;
        val =  address_bus + (int16_t)offset;
    }
}
