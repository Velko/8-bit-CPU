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
        output step_reset,
        output step_ext,
        output clk_halt,
        output clk_brk,
        output stack_inc,
        output stack_dec
    );

    assign outctl = control_word[3:0];
    assign loadctl = control_word[11:8];
    assign alu_arg_l = control_word[17:16];
    assign alu_arg_r = control_word[20:18];
    assign alu_alt = control_word[4];
    assign flags_calc = control_word[6];
    assign carry = control_word[14];
    assign addroutctl = control_word[25:23];
    assign addrloadctl = control_word[29:27];
    assign step_reset = control_word[7];
    assign step_ext = control_word[5];
    assign clk_halt = control_word[13];
    assign clk_brk = control_word[26];
    assign stack_inc = control_word[21];
    assign stack_dec = control_word[22];

endmodule