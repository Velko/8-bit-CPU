module io_control (
    inout [7:0] main_bus,
    input rst,
    input clk,

    input loadn,
    input from_devn,
    input to_devn,

    output [7:0] sel_x,
    output [7:0] sel_y,
    inout [7:0] io_bus
);

    wire [7:0] port_addr;

    dff_173 addr_low (
        .mr(rst),
        .cp(clk),
        .e1n(loadn),
        .e2n(loadn),
        .oe1n(1'b0),
        .oe2n(1'b0),
        .d(main_bus[3:0]),
        .q(port_addr[3:0])
    );

    dff_173 addr_high (
        .mr(rst),
        .cp(clk),
        .e1n(loadn),
        .e2n(loadn),
        .oe1n(1'b0),
        .oe2n(1'b0),
        .d(main_bus[7:4]),
        .q(port_addr[7:4])
    );

    demux_138 sel_mux_x (
        .a(port_addr[2:0]),
        .e1n(from_devn && to_devn),
        .e2n(1'b0),
        .e3(1'b1),
        .y(sel_x)
    );

    demux_138 sel_mux_y (
        .a(port_addr[6:4]),
        .e1n(from_devn && to_devn),
        .e2n(1'b0),
        .e3(1'b1),
        .y(sel_y)
    );

    buffer_245 io_buffer (
        .a(main_bus),
        .b(io_bus),
        .dir(from_devn),
        .oen(from_devn && to_devn)
    );

endmodule
