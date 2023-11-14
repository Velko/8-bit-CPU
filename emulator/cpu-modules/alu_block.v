`define A_OUT          0
`define B_OUT          1
`define C_OUT          2
`define D_OUT          3
`define F_OUT          4
`define ADDSUB_OUT     5
`define ANDOR_OUT      6
`define XORNOT_OUT    10
`define SHIFTSWAP_OUT  7


`define A_LOAD       0
`define B_LOAD       1
`define C_LOAD       2
`define D_LOAD       3
`define T_LOAD       6
`define F_LOAD       7

`define A_ARG_L       0
`define B_ARG_L       1
`define C_ARG_L       2
`define D_ARG_L       3

`define A_ARG_R       0
`define B_ARG_R       1
`define C_ARG_R       2
`define D_ARG_R       3
`define T_ARG_R       4

module alu_block(
        inout [7:0] main_bus,
        output [3:0] fout,

        input rst,

        input [3:0] outctl,
        input [3:0] loadctl,
        input [1:0] arg_l,
        input [2:0] arg_r,
        input alt,
        input calcfn,
        input cin,

        input clk,
        input iclk
    );


    wire [7:0] alu_arg_l;
    wire [7:0] alu_arg_r;

    wire cfb;
    wire vfb;

    gp_register a(
        .outn(out_mux.y[`A_OUT]),
        .loadn(load_mux.y[`A_LOAD]),
        .loutn(arg_l_mux.y[`A_ARG_L]),
        .routn(arg_r_mux.y[`A_ARG_R]),

        .clk(clk),
        .iclk(iclk),

        .bus(main_bus),
        .alu_l(alu_arg_l),
        .alu_r(alu_arg_r)
    );

    gp_register b(
        .outn(out_mux.y[`B_OUT]),
        .loadn(load_mux.y[`B_LOAD]),
        .loutn(arg_l_mux.y[`B_ARG_L]),
        .routn(arg_r_mux.y[`B_ARG_R]),

        .clk(clk),
        .iclk(iclk),

        .bus(main_bus),
        .alu_l(alu_arg_l),
        .alu_r(alu_arg_r)
    );

    gp_register c(
        .outn(out_mux.y[`C_OUT]),
        .loadn(load_mux.y[`C_LOAD]),
        .loutn(arg_l_mux.y[`C_ARG_L]),
        .routn(arg_r_mux.y[`C_ARG_R]),

        .clk(clk),
        .iclk(iclk),

        .bus(main_bus),
        .alu_l(alu_arg_l),
        .alu_r(alu_arg_r)
    );

    gp_register d(
        .outn(out_mux.y[`D_OUT]),
        .loadn(load_mux.y[`D_LOAD]),
        .loutn(arg_l_mux.y[`D_ARG_L]),
        .routn(arg_r_mux.y[`D_ARG_R]),

        .clk(clk),
        .iclk(iclk),

        .bus(main_bus),
        .alu_l(alu_arg_l),
        .alu_r(alu_arg_r)
    );

    gp_register t(
        .outn(1'b1),
        .loadn(load_mux.y[`T_LOAD]),
        .loutn(1'b1),
        .routn(arg_r_mux.y[`T_ARG_R]),

        .clk(clk),
        .iclk(iclk),

        .bus(main_bus),
        .alu_l(alu_arg_l),
        .alu_r(alu_arg_r)
    );

    alu_addsub addsub(
        .outn(out_mux.y[`ADDSUB_OUT]),
        .sub(alt),

        .bus(main_bus),
        .arg_l(alu_arg_l),
        .arg_r(alu_arg_r),

        .cin(cin),
        .vout(vfb),
        .cout(cfb)
    );

    alu_andor andor(
        .outn(out_mux.y[`ANDOR_OUT]),
        .fn_or(alt),

        .bus(main_bus),
        .arg_l(alu_arg_l),
        .arg_r(alu_arg_r)
    );

    alu_xornot xornot(
        .outn(out_mux.y[`XORNOT_OUT]),
        .fn_not(alt),

        .bus(main_bus),
        .arg_l(alu_arg_l),
        .arg_r(alu_arg_r)
    );

    alu_shiftswap shiftswap(
        .outn(out_mux.y[`SHIFTSWAP_OUT]),
        .fn_swap(alt),

        .bus(main_bus),
        .arg_l(alu_arg_l),

        .cin(cin),
        .cout(cfb)
    );

    flags_reg flags(
        .boutn(out_mux.y[`F_OUT]),
        .bloadn(load_mux.y[`F_LOAD]),
        .calcn(calcfn),

        .clk(clk),
        .iclk(iclk),
        .reset(rst),

        .bus(main_bus),
        .fout(fout),

        .vin(vfb),
        .cin(cfb)
    );

    demux_16 out_mux(.a(outctl));
    demux_16 load_mux(.a(loadctl));

    demux_138 arg_l_mux(.e1n(1'b0), .e2n(1'b0), .e3(1'b1), .a({1'b0, arg_l}));
    demux_138 arg_r_mux(.e1n(1'b0), .e2n(1'b0), .e3(1'b1), .a(arg_r));

    wire [7:0] z_source;
    buffer_245 arg_r_fz(.oen(arg_r_mux.y[6]), .dir(1'b1), .a(z_source), .b(alu_arg_r));
    assign z_source = 8'b0;

endmodule