module alu_block(
        inout [7:0] main_bus,

        input reset,
        input a_outn,
        input b_outn,
        input addsub_outn,

        input a_loadn,
        input b_loadn,

        input clk,
        input iclk,
        input alt,
        input calcfn

    );

    wire [7:0] alu_arg_l;
    wire [7:0] alu_arg_r;

    wire cfb;
    wire vfb;

    gp_register a(.bus(main_bus), .alu_l(alu_arg_l), .alu_r(alu_arg_r), .reset(reset), .clk(clk), .iclk(iclk), .outn(a_outn), .loadn(a_loadn), .loutn(1'b0), .routn(1'b1));
    gp_register b(.bus(main_bus), .alu_l(alu_arg_l), .alu_r(alu_arg_r), .reset(reset), .clk(clk), .iclk(iclk), .outn(b_outn), .loadn(b_loadn), .loutn(1'b1), .routn(1'b0));

    alu_addsub addsub(.bus(main_bus), .arg_l(alu_arg_l), .arg_r(alu_arg_r), .outn(addsub_outn), .sub(alt), .cin(1'b0), .vout(vfb), .cout(cfb));
    flags_reg flags(.bus(main_bus), .reset(reset), .clk(clk), .iclk(iclk), .boutn(1'b1), .bloadn(1'b1), .vin(vfb), .cin(cfb), .calcn(calcfn));

endmodule