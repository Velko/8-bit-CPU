module cpu(
        input power_on
    );

    wire [7:0] main_bus;
    wire [15:0] addr_bus;
    wire rst;
    wire clk;
    wire iclk;

    wire ctrlen;

    wire [3:0] fout;
    wire [7:0] iout;
    wire brk;
    wire hlt;

    wire [31:0] control_word;

    cword_splitter splitter(.control_word(control_word));
    alu_block alu(.main_bus(main_bus), .rst(rst), .clk(clk), .iclk(iclk), .fout(fout),
        .outctl(splitter.outctl),
        .loadctl(splitter.loadctl),
        .arg_l(splitter.alu_arg_l),
        .arg_r(splitter.alu_arg_r),
        .alt(splitter.alu_alt),
        .calcfn(splitter.alu_calcfn),
        .cin(splitter.alu_cin)
        );

    mem_block mem(.abus(addr_bus), .mbus(main_bus), .rst(rst), .clk(clk), .iclk(iclk),
        .addroutctl(splitter.addroutctl),
        .addrloadctl(splitter.addrloadctl),
        .outctl(splitter.outctl),
        .loadctl(splitter.loadctl),
        .iout(iout),
        .acincn(splitter.addr_incn),
        .acdecn(splitter.addr_decn),
        .m_sign(splitter.acalc_signed)
        );

    control_logic ctrl(.opcode(iout), .flags(fout), .rstn(!rst), .clk(clk), .iclk(iclk), .control_word(control_word), .ctrlen(ctrlen),
        .step_resetn(splitter.step_resetn),
        .step_extn(splitter.step_extn)
    );

    debug dbg(
        .main_bus(main_bus),
        .addr_bus(addr_bus),
        .brk(brk),
        .hlt(hlt),
        .power_on(power_on),
        .fout(fout),
        .iout(iout),
        .ctrlen(ctrlen),
        .rst(rst),
        .clk(clk),
        .iclk(iclk),
        .control_word(control_word)
    );

    clock clock (
        .ctrlen(ctrlen),
        .clk(clk),
        .iclk(iclk)
    );

    io_block io(
        .main_bus(main_bus),
        .clk(clk),
        .reset(rst),
        .outctl(splitter.outctl),
        .loadctl(splitter.loadctl)
    );

    assign brk = splitter.clk_brk;
    assign hlt = splitter.clk_halt;

    assign (pull0, pull1) main_bus = 8'b0;
    assign (pull0, pull1) clk = 1'b0;
    assign (pull0, pull1) iclk = 1'b0;

endmodule
