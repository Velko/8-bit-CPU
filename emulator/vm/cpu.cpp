#include "cpu.h"
#include "op-defs.h"

void CPU::off()
{
    rst = 0;
    clk = 0;
    iclk = 0;
    control_word = CTRL_DEFAULT;

    eval();
}

void CPU::reset()
{
    rst = 1;
    eval();
    rst = 0;
}

void CPU::clk_pulse()
{
    clk = 1;
    eval();
    clk = 0;
}

void CPU::iclk_pulse()
{
    iclk = 1;
    eval();
    clk = 0;
}

void CPU::clock_tick()
{
    clk = 1;
    eval();
    clk = 0;
    iclk = 1;
    eval();
    iclk = 0;
}
