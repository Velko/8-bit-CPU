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

    dff_173 prim_l(.mr(reset), .cp(clk), .e1n(loadn), .e2n(loadn), .oe1n(1'b0), .oe2n(1'b0), .d(bus[3:0]));
    dff_173 prim_h(.mr(reset), .cp(clk), .e1n(loadn), .e2n(loadn), .oe1n(1'b0), .oe2n(1'b0), .d(bus[7:4]));
    buffer_245 bus_buf(.oen(outn), .dir(1'b1), .a({prim_h.q, prim_l.q}), .b(bus));

    dff_173 sec_l(.mr(reset), .cp(iclk), .e1n(1'b0), .e2n(1'b0), .oe1n(1'b0), .oe2n(1'b0), .d(prim_l.q));
    dff_173 sec_h(.mr(reset), .cp(iclk), .e1n(1'b0), .e2n(1'b0), .oe1n(1'b0), .oe2n(1'b0), .d(prim_h.q));

    buffer_245 alu_l_buf(.oen(loutn), .dir(1'b1), .a({sec_h.q, sec_l.q}), .b(alu_l));
    buffer_245 alu_r_buf(.oen(routn), .dir(1'b1), .a({sec_h.q, sec_l.q}), .b(alu_r));

endmodule
