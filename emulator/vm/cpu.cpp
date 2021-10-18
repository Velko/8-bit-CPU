#include "cpu.h"

void CPU::off()
{
    rst = 0;
    a_outn = 1;
    b_outn = 1;
    addsub_outn = 1;
    a_loadn = 1;
    b_loadn = 1;
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