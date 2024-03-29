module dff_173(
    input mr,
    input cp,
    input e1n,
    input e2n,
    input oe1n,
    input oe2n,
    input [3:0] d,
    output [3:0] q);

    reg [3:0] data;

    assign q = !oe1n && !oe2n ? data : 4'bZ;

    always @ (posedge cp or posedge mr) begin
        if (mr)
            data <= 0;
        else if (!e1n && !e2n)
            data <= d;
    end

    /* Instantiation:
    dff_173 new_instance (
        .mr(),
        .cp(),
        .e1n(),
        .e2n(),
        .oe1n(),
        .oe2n(),
        .d(),
        .q()
    );
    */
endmodule