module demux_16(
    input [3:0] a,
    output [15:0] y
);

    demux_138 mux_l(.e1n(a[3]), .e2n(1'b0), .e3(1'b1), .a(a[2:0]), .y(y[7:0]));
    demux_138 mux_h(.e1n(1'b0), .e2n(1'b0), .e3(a[3]), .a(a[2:0]), .y(y[15:8]));

endmodule