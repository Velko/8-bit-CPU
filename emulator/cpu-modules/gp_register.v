module gp_register (
    input outn,
    input loadn,
    input loutn,
    input routn,

    input clk,
    input iclk,

    inout [7:0] bus,
    output [7:0] alu_l,
    output [7:0] alu_r);


    wire [7:0] out_v;
    wire [7:0] alu_v;

    dff_377 primary_reg (
        .cp(clk),
        .en(loadn),
        .d(bus),
        .q(out_v)
    );

    buffer_245 bus_buf(
        .oen(outn),
        .dir(1'b1),
        .a(out_v),
        .b(bus)
    );

    dff_374 secondary_l_reg (
        .cp(iclk),
        .oen(loutn),
        .d(out_v),
        .q(alu_l)
    );

    dff_374 secondary_r_reg (
        .cp(iclk),
        .oen(routn),
        .d(out_v),
        .q(alu_r)
    );

    always @(posedge clk) begin
        if (loadn == 1'b0 && ^bus === 1'bX)
            $error("Attempting to load %b", bus);
    end

endmodule
