module cpu(
        inout [7:0] main_bus,
        inout [15:0] addr_bus,
        input rst,
        input clk,
        input iclk,

        input ctrlen,

        output [3:0] fout,
        output [7:0] iout,

        input crstn,
        output brk,

        inout [31:0] control_word
    );

    cword_splitter splitter(.control_word(control_word));
    alu_block alu(.main_bus(main_bus), .rst(rst), .clk(clk), .iclk(iclk), .fout(fout),
        .outctl(splitter.outctl),
        .loadctl(splitter.loadctl),
        .arg_l(splitter.alu_arg_l),
        .arg_r(splitter.alu_arg_r),
        .alt(splitter.alu_alt),
        .calcfn(splitter.flags_calc),
        .cin(splitter.carry));

    mem_block mem(.abus(addr_bus), .mbus(main_bus), .rst(rst), .rstn(!rst), .clk(clk), .iclk(iclk),
        .addroutctl(splitter.addroutctl),
        .addrloadctl(splitter.addrloadctl),
        .outctl(splitter.outctl),
        .loadctl(splitter.loadctl),
        .iout(iout),
        .spinc(splitter.stack_inc),
        .spdec(splitter.stack_dec)
        );

    control_logic ctrl(.opcode(iout), .flags(fout), .rstn(crstn), .iclk(iclk), .control_word(control_word), .ctrlen(ctrlen),
        .step_reset(splitter.step_reset),
        .step_ext(splitter.step_ext)
    );

    assign brk = splitter.clk_brk;

endmodule
