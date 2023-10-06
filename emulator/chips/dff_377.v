module dff_377(
    input cp,
    input en,
    input [7:0] d,
    output [7:0] q);

    reg [7:0] data;

    assign q = data;

    always @ (posedge cp) begin
        if (!en)
            data <= d;
    end

    /* Instantiation:
    dff_377 new_instance (
        .cp(),
        .en(),
        .d(),
        .q()
    );
    */
endmodule