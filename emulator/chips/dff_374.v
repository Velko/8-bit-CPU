module dff_374(
    input cp,
    input oen,
    input [7:0] d,
    output [7:0] q);

    reg [7:0] data;

    assign q = !oen ? data : 8'bZ;

    always @ (posedge cp) begin
        data <= d;
    end

    /* Instantiation:
    dff_374 new_instance (
        .cp(),
        .oen(),
        .d(),
        .q()
    );
    */
endmodule