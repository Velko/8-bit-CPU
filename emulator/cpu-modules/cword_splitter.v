`define OUT_MUX          3:0
`define LOAD_MUX         7:4
`define ALU_ARG_L_MUX    9:8
`define ALU_ARG_R_MUX   12:10
`define ALU_ALT            13
`define ALU_CALCF          14
`define ALU_CIN            15
`define ADDR_OUT_MUX    18:16
`define ADDR_LOAD_MUX   21:19
`define STACK_INC          22
`define STACK_DEC          23
`define STEP_RESET         24
`define STEP_EXT           25
`define CLK_HLT            26
`define CLK_BRK            27
`define ACALC_SIGNED       28

module cword_splitter(
        input [31:0] control_word,

        output [3:0] outctl,
        output [3:0] loadctl,
        output [1:0] alu_arg_l,
        output [2:0] alu_arg_r,
        output alu_alt,
        output alu_calcfn,
        output alu_cin,

        output [2:0] addroutctl,
        output [2:0] addrloadctl,
        output step_resetn,
        output step_extn,
        output clk_halt,
        output clk_brk,
        output stack_inc,
        output stack_dec,
        output acalc_signed
    );

    // ROM0 - Main Bus
    assign outctl = control_word[`OUT_MUX];
    assign loadctl = control_word[`LOAD_MUX];

    // ROM1 - ALU
    assign alu_arg_l = control_word[`ALU_ARG_L_MUX];
    assign alu_arg_r = control_word[`ALU_ARG_R_MUX];
    assign alu_alt = control_word[`ALU_ALT];
    assign alu_calcfn = control_word[`ALU_CALCF];
    assign alu_cin = control_word[`ALU_CIN];

    // ROM2 - Address Bus
    assign addroutctl = control_word[`ADDR_OUT_MUX];
    assign addrloadctl = control_word[`ADDR_LOAD_MUX];
    assign stack_inc = control_word[`STACK_INC];
    assign stack_dec = control_word[`STACK_DEC];

    // ROM3 - Misc.
    assign step_resetn = control_word[`STEP_RESET];
    assign step_extn = control_word[`STEP_EXT];
    assign clk_halt = control_word[`CLK_HLT];
    assign clk_brk = control_word[`CLK_BRK];
    assign acalc_signed = control_word[`ACALC_SIGNED];

endmodule