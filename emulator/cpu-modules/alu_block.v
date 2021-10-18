module alu_block(
        inout [7:0] main_bus,
        output [3:0] fout,

        input rst,
        input [2:0] outctl,

        input [2:0] loadctl,

        input clk,
        input iclk,
        input alt,
        input calcfn

    );

    wire [7:0] alu_arg_l;
    wire [7:0] alu_arg_r;

    // for some crazy reason, Verilator thinks wires are unused
    /* verilator lint_off UNUSED */
    wire cfb;
    wire vfb;
    /* verilator lint_on UNUSED */

    /* verilator lint_off PINMISSING */
    gp_register a(.bus(main_bus), .alu_l(alu_arg_l), .alu_r(alu_arg_r), .reset(rst), .clk(clk), .iclk(iclk), .outn(out_mux.y[0]), .loadn(load_mux.y[0]), .loutn(1'b0), .routn(1'b1));
    gp_register b(.bus(main_bus), .alu_l(alu_arg_l), .alu_r(alu_arg_r), .reset(rst), .clk(clk), .iclk(iclk), .outn(out_mux.y[1]), .loadn(load_mux.y[1]), .loutn(1'b1), .routn(1'b0));

    alu_addsub addsub(.bus(main_bus), .arg_l(alu_arg_l), .arg_r(alu_arg_r), .outn(out_mux.y[2]), .sub(alt), .cin(1'b0), .vout(vfb), .cout(cfb));
    flags_reg flags(.bus(main_bus), .reset(rst), .clk(clk), .iclk(iclk), .boutn(1'b1), .bloadn(1'b1), .vin(vfb), .cin(cfb), .calcn(calcfn), .fout(fout));

    demux_138 out_mux(.e1n(1'b0), .e2n(1'b0), .e3(1'b1), .a(outctl));
    demux_138 load_mux(.e1n(1'b0), .e2n(1'b0), .e3(1'b1), .a(loadctl));

endmodule