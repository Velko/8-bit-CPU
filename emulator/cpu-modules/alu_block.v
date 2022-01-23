module alu_block(
        inout [7:0] main_bus,
        output [3:0] fout,

        input rst,
        input [3:0] outctl,
        input [3:0] loadctl,

        input [1:0] arg_l,
        input [2:0] arg_r,

        input clk,
        input iclk,
        input alt,
        input calcfn,
        input cin

    );

    wire [7:0] alu_arg_l;
    wire [7:0] alu_arg_r;

    wire cfb;
    wire vfb;

    gp_register a(.bus(main_bus), .alu_l(alu_arg_l), .alu_r(alu_arg_r), .reset(rst), .clk(clk), .iclk(iclk), .outn(out_mux_l.y[0]), .loadn(load_mux_l.y[0]), .loutn(arg_l_mux.y[0]), .routn(arg_r_mux.y[0]));
    gp_register b(.bus(main_bus), .alu_l(alu_arg_l), .alu_r(alu_arg_r), .reset(rst), .clk(clk), .iclk(iclk), .outn(out_mux_l.y[1]), .loadn(load_mux_l.y[1]), .loutn(arg_l_mux.y[1]), .routn(arg_r_mux.y[1]));
    gp_register c(.bus(main_bus), .alu_l(alu_arg_l), .alu_r(alu_arg_r), .reset(rst), .clk(clk), .iclk(iclk), .outn(out_mux_l.y[2]), .loadn(load_mux_l.y[2]), .loutn(arg_l_mux.y[2]), .routn(arg_r_mux.y[2]));
    gp_register d(.bus(main_bus), .alu_l(alu_arg_l), .alu_r(alu_arg_r), .reset(rst), .clk(clk), .iclk(iclk), .outn(out_mux_l.y[3]), .loadn(load_mux_l.y[3]), .loutn(arg_l_mux.y[3]), .routn(arg_r_mux.y[3]));

    alu_addsub addsub(.bus(main_bus), .arg_l(alu_arg_l), .arg_r(alu_arg_r), .outn(out_mux_l.y[5]), .sub(alt), .cin(cin), .vout(vfb), .cout(cfb));
    alu_andor andor(.bus(main_bus), .arg_l(alu_arg_l), .arg_r(alu_arg_r), .outn(out_mux_l.y[6]), .fn_or(alt));
    alu_xornot xornot(.bus(main_bus), .arg_l(alu_arg_l), .arg_r(alu_arg_r), .outn(out_mux_h.y[2]), .fn_not(alt));
    alu_shiftswap shiftswap(.bus(main_bus), .arg_l(alu_arg_l), .outn(out_mux_l.y[7]), .fn_swap(alt), .cin(cin), .cout(cfb));
    flags_reg flags(.bus(main_bus), .reset(rst), .clk(clk), .iclk(iclk), .boutn(out_mux_l.y[4]), .bloadn(load_mux_l.y[7]), .vin(vfb), .cin(cfb), .calcn(calcfn), .fout(fout));

    demux_138 out_mux_l(.e1n(outctl[3]), .e2n(1'b0), .e3(1'b1), .a(outctl[2:0]));
    demux_138 load_mux_l(.e1n(loadctl[3]), .e2n(1'b0), .e3(1'b1), .a(loadctl[2:0]));
    demux_138 out_mux_h(.e1n(1'b0), .e2n(1'b0), .e3(outctl[3]), .a(outctl[2:0]));
    demux_138 load_mux_h(.e1n(1'b0), .e2n(1'b0), .e3(loadctl[3]), .a(loadctl[2:0]));

    demux_138 arg_l_mux(.e1n(1'b0), .e2n(1'b0), .e3(1'b1), .a({1'b0, arg_l}));
    demux_138 arg_r_mux(.e1n(1'b0), .e2n(1'b0), .e3(1'b1), .a(arg_r));

    wire [7:0] z_source;
    buffer_245 arg_r_fz(.oen(arg_r_mux.y[6]), .dir(1'b1), .a(z_source), .b(alu_arg_r));
    assign z_source = 8'b0;

endmodule