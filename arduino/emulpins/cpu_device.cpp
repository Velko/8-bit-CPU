#include "devices.h"

ControlSignal::ControlSignal(cword_t mask, cword_t bits)
    : _mask{mask}, _bits{bits}
{}

ControlSignal::ControlSignal(bool on)
    : _mask{0}, _bits{on ? 0UL : 1UL}
{}

bool ControlSignal::is_enabled(cword_t control)
{
    return (control & _mask) == _bits;
}

void CpuDevice::apply_control(cword_t control)
{
    _control = control;
    control_updated();
}

void CpuDevice::control_updated() {}
void CpuDevice::clock_pulse() {}
void CpuDevice::clock_inverted() {}