#include "clock.h"

Clock::Clock(int _pin)
    : OutPinH{_pin}
{
}
void Clock::pulse()
{
    on();
    off();
}