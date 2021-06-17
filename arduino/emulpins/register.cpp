#include "devices.h"
#include "op-defs.h"

Register::Register(cword_t out, cword_t load, cword_t tap_l, cword_t tap_r)
    : _out(MUX_OUT_MASK, out),
      _load(MUX_LOAD_MASK, load),
      _tap_l(MUX_ALUARGL_MASK, tap_l),
      _tap_r(MUX_ALUARGR_MASK, tap_r)
{}

void Register::clock_pulse()
{
    if (_load.is_enabled(_control))
        latched_primary = main_bus;
}

void Register::clock_inverted()
{
    latched_secondary = latched_primary;
}

void Register::control_updated()
{
    if (_out.is_enabled(_control))
        main_bus = latched_primary;
    if (_tap_l.is_enabled(_control))
        alu_arg_l_bus = latched_secondary;
    if (_tap_r.is_enabled(_control))
        alu_arg_r_bus = latched_secondary;
}

uint8_t Register::read_tap()
{
    return latched_secondary;
}

void AddressReg::set_load(bool enabled)
{
    load_enabled = enabled;
}

void AddressReg::set_out(bool enabled)
{
    if (enabled) {
        address_bus = val;
    }
}

void AddressReg::clock_pulse()
{
    if (load_enabled)
    {
        val = address_bus;
    }
}