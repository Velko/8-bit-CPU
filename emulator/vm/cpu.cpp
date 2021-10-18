#include "cpu.h"

void CPU::off()
{
    rst = 0;
    outctl = 15;
    loadctl = 15;
    arg_l = 0;
    arg_r = 6;
    clk = 0;
    iclk = 0;
    alt = 0;
    calcfn = 1;

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