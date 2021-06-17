#include "devices.h"
#include "op-defs.h"

InstructionRegister::InstructionRegister(cword_t load)
    : _load(MUX_LOAD_MASK, load)
{}

void InstructionRegister::apply_control(cword_t control)
{
    _control = control;
}

uint8_t InstructionRegister::read_tap()
{
    return latched_secondary;
}

void InstructionRegister::clock_pulse()
{
    if (_load.is_enabled(_control))
        latched_primary = main_bus;
}

void InstructionRegister::clock_inverted()
{
    latched_secondary = latched_primary;
}