#include "cpu.h"
#include "op-defs.h"

void CPU::off()
{
    rst = 0;
    clk = 0;
    iclk = 0;
    control_word = CTRL_DEFAULT;
    send_main_bus = false;

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

void CPU::set_control_word(uint32_t word)
{
    // if nothing drives the bus, eval() resets it to 0
    uint8_t smbus = main_bus;

    control_word = word;
    eval();

    // but we may want like to keep what was there before
    if (send_main_bus)
        main_bus = smbus;
}

void CPU::main_bus_write(uint8_t data)
{
    send_main_bus = true;
    main_bus =  data;
}

void CPU::main_bus_set_input()
{
    send_main_bus = false;
}
