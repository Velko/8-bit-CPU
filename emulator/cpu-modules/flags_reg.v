module flags_reg(
    input boutn,
    input bloadn,
    input calcn,

    input clk,
    input iclk,
    input reset,

    inout [7:0] bus,

    input vin,
    input cin,

    output [3:0] fout);

    wire cval;
    wire vval;

    dff_173 reg_prim(.mr(reset), .cp(clk), .oe1n(1'b0), .oe2n(1'b0), .e1n(zc_and.y4), .e2n(zc_and.y4), .d(mx.y));
    dff_173 reg_sec(.mr(reset), .cp(iclk), .oe1n(1'b0), .oe2n(1'b0), .e1n(1'b0), .e2n(1'b0), .d(reg_prim.q), .q(fout));

    nor_02b zc_nor(.a(bus[7:4]), .b(bus[3:0]));
    and_08p zc_and(.a1(zc_nor.y[0]), .a2(zc_nor.y[1]), .b1(zc_nor.y[2]), .b2(zc_nor.y[3]), .a3(zc_and.y1), .b3(zc_and.y2), .a4(bloadn), .b4(calcn));

    mux_157b mx(.a({vval, cval, zc_and.y3, bus[7]}), .b(bus[3:0]), .en(1'b0), .sel(calcn));

    buffer_125p out_buf(.oen1(boutn), .oen2(boutn), .oen3(boutn), .oen4(boutn),
                        .a1(reg_prim.q[0]), .a2(reg_prim.q[1]), .a3(reg_prim.q[2]), .a4(reg_prim.q[3]),
                        .y1(bus[0]), .y2(bus[1]), .y3(bus[2]), .y4(bus[3]));

    // not all ALU modules produces V and C, use old value if input is Z
    // in real hardware this is implemented using a pulling resistor
    assign cval = cin !== 1'bz ? cin : reg_prim.q[2];
    assign vval = vin !== 1'bz ? vin : reg_prim.q[3];

    initial begin
       // $monitor("prim: %b", reg_prim.q);
    end

endmodule
