#include <cstdio>
#include "Valu_block.h"

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

    Valu_block *alu = new Valu_block();

    alu->reset = 0;
    alu->a_loadn = 1;
    alu->b_loadn = 1;
    //fout,

    alu->a_outn = 1;
    alu->b_outn = 1;
    alu->addsub_outn = 1;

    alu->clk = 0;
    alu->iclk = 0;
    alu->alt = 0;
    alu->calcfn = 1;

    alu->eval();

    VL_PRINTF("%d\n", alu->main_bus);

    alu->main_bus = 24;

    alu->a_loadn = 0;

    alu->eval();
    VL_PRINTF("%d\n", alu->main_bus);
    alu->main_bus = 24;
    alu->clk = 1;
    alu->eval();
    alu->clk = 0;

    alu->a_loadn = 1;
    alu->a_outn = 0;
    alu->eval();
    VL_PRINTF("%d\n", alu->main_bus);

    alu->iclk = 1;

    alu->eval();

    alu->iclk = 0;
    alu->a_loadn = 1;
    alu->b_loadn = 0;
    alu->main_bus = 18;
    alu->eval();
    alu->clk = 1;
    alu->eval();

    alu->clk = 0;
    alu->iclk = 1;

    alu->eval();

    alu->iclk = 0;
    alu->b_loadn = 1;

    alu->b_outn = 0;
    alu->eval();

    VL_PRINTF("%d\n", alu->main_bus);

    // Final model cleanup
    alu->final();

    delete alu;

    return 0;
}