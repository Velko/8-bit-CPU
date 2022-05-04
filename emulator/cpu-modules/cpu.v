module cpu(
        inout [7:0] main_bus,
        inout [15:0] addr_bus,
        input rst,
        input clk,
        input iclk,

        input ctrlen,

        output [3:0] fout,
        output [7:0] iout,

        output brk,
        output hlt,
        output [7:0] i_out,
        output [7:0] c_out,
        input out_rst,

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

    control_logic ctrl(.opcode(iout), .flags(fout), .rstn(!rst), .clk(clk), .iclk(iclk), .control_word(control_word), .ctrlen(ctrlen),
        .step_resetn(splitter.step_resetn),
        .step_extn(splitter.step_extn)
    );

    io_block io(
        .main_bus(main_bus),
        .clk(clk),
        .reset(rst),
        .out_rst(out_rst),
        .i_out(i_out),
        .c_out(c_out),
        .outctl(splitter.outctl),
        .loadctl(splitter.loadctl)
    );

    assign brk = splitter.clk_brk;
    assign hlt = splitter.clk_halt;

endmodule
