module cword_splitter(
        /* verilator lint_off UNUSED */
        input [31:0] control_word,
        /* verilator lint_on UNUSED */

        output [3:0] outctl,
        output [3:0] loadctl,
        output [1:0] alu_arg_l,
        output [2:0] alu_arg_r,
        output alu_alt,
        output flags_calc,
        output carry
    );

    assign outctl = control_word[3:0];
    assign loadctl = control_word[11:8];
    assign alu_arg_l = control_word[17:16];
    assign alu_arg_r = control_word[20:18];
    assign alu_alt = control_word[4];
    assign flags_calc = control_word[6];
    assign carry = control_word[14];

endmodule