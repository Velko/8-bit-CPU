module alu_andor (
    input outn,
    input fn_or,
    input [7:0] arg_l,
    input [7:0] arg_r,
    output [7:0] bus);

    // for some crazy reason, Verilator thinks wire is unused
    /* verilator lint_off UNUSED */
    wire [7:0] out_v;
    /* verilator lint_on UNUSED */

    /* verilator lint_off PINMISSING */
    and_08b and_l(.a(arg_l[3:0]), .b(arg_r[3:0]));
    and_08b and_h(.a(arg_l[7:4]), .b(arg_r[7:4]));

    or_32b or_l(.a(arg_l[3:0]), .b(arg_r[3:0]));
    or_32b or_h(.a(arg_l[7:4]), .b(arg_r[7:4]));

    mux_157b sel_l(.a(and_l.y), .b(or_l.y), .y(out_v[3:0]), .sel(fn_or), .en(1'b0));
    mux_157b sel_h(.a(and_h.y), .b(or_h.y), .y(out_v[7:4]), .sel(fn_or), .en(1'b0));

    buffer_245 bus_buf(.oen(outn), .dir(1'b1), .a(out_v), .b(bus));

endmodule