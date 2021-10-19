module cpu(
        inout [7:0] main_bus,
        input rst,
        input clk,
        input iclk,

        /* verilator lint_off UNUSED */
        input [31:0] control_word
    );

    /* verilator lint_off PINMISSING */
    alu_block alu(.main_bus(main_bus), .rst(rst), .clk(clk), .iclk(iclk),
        .outctl(control_word[3:0]),
        .loadctl(control_word[11:8]),
        .arg_l(control_word[17:16]),
        .arg_r(control_word[20:18]),
        .alt(control_word[4]),
        .calcfn(control_word[6]),
        .cin(control_word[14]));

endmodule
