module i_register (
    input loadn,

    input clk,
    input iclk,
    input reset,

    input [7:0] bus,
    output [7:0] instr_out);


    wire [7:0] out_v;
    wire [7:0] alu_v;

    dff_173 prim_l(.mr(reset), .cp(clk), .e1n(loadn), .e2n(loadn), .oe1n(1'b0), .oe2n(1'b0), .d(bus[3:0]), .q(out_v[3:0]));
    dff_173 prim_h(.mr(reset), .cp(clk), .e1n(loadn), .e2n(loadn), .oe1n(1'b0), .oe2n(1'b0), .d(bus[7:4]), .q(out_v[7:4]));

    dff_173 sec_l(.mr(reset), .cp(iclk), .e1n(1'b0), .e2n(1'b0), .oe1n(1'b0), .oe2n(1'b0), .d(prim_l.q), .q(instr_out[3:0]));
    dff_173 sec_h(.mr(reset), .cp(iclk), .e1n(1'b0), .e2n(1'b0), .oe1n(1'b0), .oe2n(1'b0), .d(prim_h.q), .q(instr_out[7:4]));

    always @(posedge clk) begin
        if (loadn == 1'b0 && ^bus === 1'bX)
            $error("Attempting to load %b", bus);
    end

endmodule
