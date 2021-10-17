module gp_register (
    input outn,
    input loadn,
    input loutn,
    input routn,

    input clk,
    input iclk,
    input reset,

    inout [7:0] bus,
    output [7:0] alu_l,
    output [7:0] alu_r);


    // for some crazy reason, Verilator thinks wires are unused
    /* verilator lint_off UNUSED */
    wire [7:0] out_v;
    wire [7:0] alu_v;
    /* verilator lint_on UNUSED */

    /* verilator lint_off PINMISSING */
    dff_173 prim_l(.mr(reset), .cp(clk), .e1n(loadn), .e2n(loadn), .oe1n(1'b0), .oe2n(1'b0), .d(bus[3:0]), .q(out_v[3:0]));
    dff_173 prim_h(.mr(reset), .cp(clk), .e1n(loadn), .e2n(loadn), .oe1n(1'b0), .oe2n(1'b0), .d(bus[7:4]), .q(out_v[7:4]));
    buffer_245 bus_buf(.oen(outn), .dir(1'b1), .a(out_v), .b(bus));

    dff_173 sec_l(.mr(reset), .cp(iclk), .e1n(1'b0), .e2n(1'b0), .oe1n(1'b0), .oe2n(1'b0), .d(prim_l.q), .q(alu_v[3:0]));
    dff_173 sec_h(.mr(reset), .cp(iclk), .e1n(1'b0), .e2n(1'b0), .oe1n(1'b0), .oe2n(1'b0), .d(prim_h.q), .q(alu_v[7:4]));

    buffer_245 alu_l_buf(.oen(loutn), .dir(1'b1), .a(alu_v), .b(alu_l));
    buffer_245 alu_r_buf(.oen(routn), .dir(1'b1), .a(alu_v), .b(alu_r));

endmodule
