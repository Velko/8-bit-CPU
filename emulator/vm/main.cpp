#include <cstdio>
#include "cpu.h"

int main(int argc, char **argv)
{
    printf("Very lating\n");
        // Set debug level, 0 is off, 9 is highest presently used
    // May be overridden by commandArgs
    Verilated::debug(0);

    // Randomization reset policy
    // May be overridden by commandArgs
    Verilated::randReset(2);

    // Verilator must compute traced signals
    Verilated::traceEverOn(true);

    // Pass arguments so Verilated code can see them, e.g. $value$plusargs
    // This needs to be called before you create any model
    Verilated::commandArgs(argc, argv);

    // Create logs/ directory in case we have traces to put under it
    Verilated::mkdir("logs");

    CPU *alu = new CPU();

    alu->off();

    alu->reset();

    VL_PRINTF("%d\n", alu->main_bus);

    // Load 24 into A
    alu->a_loadn = 0;
    alu->eval();
    alu->main_bus = 24;
    alu->clock_tick();
    alu->a_loadn = 1;

    // Output A on to the bus
    alu->a_outn = 0;
    alu->eval();
    VL_PRINTF("%d\n", alu->main_bus);
    alu->a_outn = 1;

    // Load 18 into B
    alu->b_loadn = 0;
    alu->eval();
    alu->main_bus = 18;
    alu->clock_tick();
    alu->b_loadn = 1;

    // Add A to B, load result into A
    alu->addsub_outn = 0;
    alu->a_loadn = 0;
    alu->calcfn = 0;
    alu->eval();
    alu->clock_tick();
    alu->addsub_outn = 1;
    alu->a_loadn = 1;
    alu->calcfn = 1;

    // Output A on to the bus once more
    alu->a_outn = 0;
    alu->eval();
    VL_PRINTF("%d %x\n", alu->main_bus, alu->fout);
    alu->a_outn = 1;


    // Load value into B, so that it wraps around to 0, should produce -CZ- flags
    alu->b_loadn = 0;
    alu->eval();
    alu->main_bus = 256 - 42;
    alu->clock_tick();
    alu->b_loadn = 1;

    // Add A to B, load result into A
    alu->addsub_outn = 0;
    alu->a_loadn = 0;
    alu->calcfn = 0;
    alu->eval();
    alu->clock_tick();
    alu->addsub_outn = 1;
    alu->a_loadn = 1;
    alu->calcfn = 1;

    // Output A on to the bus once more
    alu->a_outn = 0;
    alu->eval();
    VL_PRINTF("%d %x\n", alu->main_bus, alu->fout);
    alu->a_outn = 1;

    // Final model cleanup
    alu->final();

    delete alu;

    return 0;
}
