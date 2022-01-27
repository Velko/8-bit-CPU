module cword_splitter(
        input [31:0] control_word,

        output [3:0] outctl,
        output [3:0] loadctl,
        output [1:0] alu_arg_l,
        output [2:0] alu_arg_r,
        output alu_alt,
        output flags_calc,
        output carry,
        output [2:0] addroutctl,
        output [2:0] addrloadctl,
        output step_resetn,
        output step_extn,
        output clk_halt,
        output clk_brk,
        output stack_inc,
        output stack_dec
    );

    // ROM0 - Main Bus
    assign outctl = control_word[3:0];
    assign loadctl = control_word[7:4];

    // ROM1 - ALU
    assign alu_arg_l = control_word[9:8];
    assign alu_arg_r = control_word[12:10];
    assign alu_alt = control_word[13];
    assign flags_calc = control_word[14];
    assign carry = control_word[15];

    // ROM2 - Address Bus
    assign addroutctl = control_word[18:16];
    assign addrloadctl = control_word[21:19];
    assign stack_inc = control_word[22];
    assign stack_dec = control_word[23];

    // ROM3 - Misc.
    assign step_resetn = control_word[24];
    assign step_extn = control_word[25];
    assign clk_halt = control_word[26];
    assign clk_brk = control_word[27];

endmodule