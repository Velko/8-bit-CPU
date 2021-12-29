module tx_register (
    input aoutn,
    input aloadn,
    input moutn,
    input mloadn,

    input clk,
    input iclk,
    input reset,

    inout [7:0] mbus,
    inout [7:0] abus);


    wire [7:0] out_v;

    and_08p load_en(.a1(aloadn), .b1(mloadn), .a2(1'b0), .b2(1'b0), .a3(1'b0), .b3(1'b0), .a4(1'b0), .b4(1'b0));

    mux_157b sel_in_l(.a(mbus[3:0]), .b(abus[3:0]), .en(1'b0), .sel(mloadn));
    mux_157b sel_in_h(.a(mbus[7:4]), .b(abus[7:4]), .en(1'b0), .sel(mloadn));

    dff_173 prim_l(.mr(reset), .cp(clk), .e1n(load_en.y1), .e2n(load_en.y1), .oe1n(1'b0), .oe2n(1'b0), .d(sel_in_l.y), .q(out_v[3:0]));
    dff_173 prim_h(.mr(reset), .cp(clk), .e1n(load_en.y1), .e2n(load_en.y1), .oe1n(1'b0), .oe2n(1'b0), .d(sel_in_h.y), .q(out_v[7:4]));

    buffer_245 mbus_buf(.oen(moutn), .dir(1'b1), .a(out_v), .b(mbus));
    buffer_245 abus_buf(.oen(aoutn), .dir(1'b1), .a(out_v), .b(abus));

endmodule
