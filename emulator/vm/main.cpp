#include <cstdio>
#include "cpu.h"
#include "op-defs.h"
#include "microcode.h"

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
    APPLY_MUX(alu->control_word, MUX_LOAD_MASK, MPIN_A_LOAD_BITS);
    alu->eval();
    alu->main_bus = 24;
    alu->clock_tick();
    alu->control_word = CTRL_DEFAULT;

    // Output A on to the bus
    APPLY_MUX(alu->control_word, MUX_OUT_MASK, MPIN_A_OUT_BITS);
    alu->eval();
    VL_PRINTF("%d\n", alu->main_bus);
    alu->control_word = CTRL_DEFAULT;

    // Load 18 into B
    APPLY_MUX(alu->control_word, MUX_LOAD_MASK, MPIN_B_LOAD_BITS);
    alu->eval();
    alu->main_bus = 18;
    alu->clock_tick();
    alu->control_word = CTRL_DEFAULT;

    // Add A to B, load result into A
    APPLY_MUX(alu->control_word, MUX_OUT_MASK, MPIN_ADDSUB_OUT_BITS);
    APPLY_MUX(alu->control_word, MUX_LOAD_MASK, MPIN_A_LOAD_BITS);
    APPLY_LPIN(alu->control_word, LPIN_F_CALC_BIT);
    APPLY_MUX(alu->control_word, MUX_ALUARGL_MASK, MPIN_A_ALU_L_BITS);
    APPLY_MUX(alu->control_word, MUX_ALUARGR_MASK, MPIN_B_ALU_R_BITS);
    alu->eval();
    alu->clock_tick();
    alu->control_word = CTRL_DEFAULT;

    // Output A on to the bus, show the result
    APPLY_MUX(alu->control_word, MUX_OUT_MASK, MPIN_A_OUT_BITS);
    alu->eval();
    VL_PRINTF("%d %x\n", alu->main_bus, alu->fout);
    alu->control_word = CTRL_DEFAULT;

    // Load value into B, so that it wraps around to 0, should produce -CZ- flags
    APPLY_MUX(alu->control_word, MUX_LOAD_MASK, MPIN_B_LOAD_BITS);
    alu->eval();
    alu->main_bus = 256 - 42;
    alu->clock_tick();
    alu->control_word = CTRL_DEFAULT;

    // Add A to B, load result into A
    APPLY_MUX(alu->control_word, MUX_OUT_MASK, MPIN_ADDSUB_OUT_BITS);
    APPLY_MUX(alu->control_word, MUX_LOAD_MASK, MPIN_A_LOAD_BITS);
    APPLY_LPIN(alu->control_word, LPIN_F_CALC_BIT);
    APPLY_MUX(alu->control_word, MUX_ALUARGL_MASK, MPIN_A_ALU_L_BITS);
    APPLY_MUX(alu->control_word, MUX_ALUARGR_MASK, MPIN_B_ALU_R_BITS);
    alu->eval();
    alu->clock_tick();
    alu->control_word = CTRL_DEFAULT;

    // Output A on to the bus once more
    APPLY_MUX(alu->control_word, MUX_OUT_MASK, MPIN_A_OUT_BITS);
    alu->eval();
    VL_PRINTF("%d %x\n", alu->main_bus, alu->fout);
    alu->control_word = CTRL_DEFAULT;

    // Final model cleanup
    alu->final();

    delete alu;

    return 0;
}
