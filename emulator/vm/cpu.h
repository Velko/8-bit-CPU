#ifndef CPU_H
#define CPU_H

#include "Vcpu.h"

class CPU : public Vcpu
{
public:
    void off();
    void reset();
    void clk_pulse();
    void iclk_pulse();
    void clock_tick();
};


#endif /* CPU_H */
