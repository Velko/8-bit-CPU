#ifndef CPU_H
#define CPU_H

#include "Valu_block.h"

class CPU : public Valu_block
{
public:
    void off();
    void reset();
    void clk_pulse();
    void iclk_pulse();
    void clock_tick();
};


#endif /* CPU_H */