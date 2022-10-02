module tlatch_373(
    input oen,
    input le,
    input [7:0] d,
    output [7:0] q);

    reg [7:0] data;

    assign q = !oen ? data : 8'bZ;

    always @ (d) begin
        if (le)
            data <= d;
    end

    always @ (posedge le) begin
        data <= d;
    end

    /* Instantiation:
    tlatch_373 new_instance (
        .oen(),
        .le(),
        .d(),
        .q()
    );
    */
endmodule