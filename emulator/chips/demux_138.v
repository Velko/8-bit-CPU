module demux_138 (
    input [2:0] a,
    input e1n,
    input e2n,
    input e3,
    output [7:0] y);

    assign y = ~({7'h0, (!e1n && !e2n && e3)} << a);

    /* Instantiation:
    demux_138 new_instance (
        .a(),
        .e1n(),
        .e2n(),
        .e3(),
        .y()
    );
    */
endmodule
