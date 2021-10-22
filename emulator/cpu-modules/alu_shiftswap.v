module alu_shiftswap (
    input outn,
    input fn_swap,
    input [7:0] arg_l,
    input cin,
    output [7:0] bus,
    output cout);

    /* verilator lint_off UNUSED */
    wire [7:0] out_v;
    /* verilator lint_on UNUSED */

    /* verilator lint_off PINMISSING */
    mux_157b sel_l(.a(arg_l[4:1]), .b(arg_l[7:4]), .y(out_v[3:0]), .sel(fn_swap), .en(1'b0));
    mux_157b sel_h(.a({cin, arg_l[7:5]}), .b(arg_l[3:0]), .y(out_v[7:4]), .sel(fn_swap), .en(1'b0));

    buffer_245 bus_buf(.oen(outn), .dir(1'b1), .a(out_v), .b(bus));

    buffer_125p flags_buf(.a1(arg_l[0]), .y1(cout),
                          .a2(1'b0), .a3(1'b0), .a4(1'b0),
                          .oen1(outn), .oen2(outn), .oen3(outn), .oen4(outn));

endmodule