#include "devices.h"

Register::Register(ControlSignal out, ControlSignal load, ControlSignal tap_l, ControlSignal tap_r)
    : _out{out}, _load{load}, _tap_l{tap_l}, _tap_r{tap_r}
{
}

void Register::clock_pulse()
{
    if (_load.is_enabled(_control))
        latched_primary = main_bus;
}

void Register::clock_inverted()
{
    latched_secondary = latched_primary;
}

void Register::apply_control(cword_t control)
{
    _control = control;
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