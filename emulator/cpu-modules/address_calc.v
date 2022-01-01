module address_calc (
    input outn,
    input loadn,

    input clk,
    input reset,

    inout [15:0] abus,
    input [7:0] mbus
);

    wire [15:0] out_v;
    wire [3:0] sign_ext;

    dff_173 outst_0(.mr(reset), .cp(clk), .e1n(loadn), .e2n(loadn), .oe1n(1'b0), .oe2n(1'b0), .d(add_0.s), .q(out_v[3:0]));
    dff_173 outst_1(.mr(reset), .cp(clk), .e1n(loadn), .e2n(loadn), .oe1n(1'b0), .oe2n(1'b0), .d(add_1.s), .q(out_v[7:4]));
    dff_173 outst_2(.mr(reset), .cp(clk), .e1n(loadn), .e2n(loadn), .oe1n(1'b0), .oe2n(1'b0), .d(add_2.s), .q(out_v[11:8]));
    dff_173 outst_3(.mr(reset), .cp(clk), .e1n(loadn), .e2n(loadn), .oe1n(1'b0), .oe2n(1'b0), .d(add_3.s), .q(out_v[15:12]));

    adder_283 add_0(.a(abus[3:0]), .b(mbus[3:0]), .cin(1'b0));
    adder_283 add_1(.a(abus[7:4]), .b(mbus[7:4]), .cin(add_0.cout));
    adder_283 add_2(.a(abus[11:8]), .b(sign_ext), .cin(add_1.cout));
    adder_283 add_3(.a(abus[15:12]), .b(sign_ext), .cin(add_2.cout));

    buffer_245 out_0(.oen(outn), .dir(1'b1), .a(out_v[7:0]), .b(abus[7:0]));
    buffer_245 out_1(.oen(outn), .dir(1'b1), .a(out_v[15:8]), .b(abus[15:8]));

    assign sign_ext = {mbus[7], mbus[7], mbus[7], mbus[7]};

endmodule
