module shift_595 (
    input ds,
    input oen,
    input cp_st,
    input cp_sh,
    input mrn,
    output q7p,
    output [7:0] q);

    reg [7:0] store;
    reg [7:0] shift;

    assign q = !oen ? store : 8'bZ;
    assign q7p = shift[7];

    always @(negedge mrn) begin
        store <= 0;
        shift <= 0;
    end

    always @(posedge cp_st) begin
        if (!mrn)
            store <= 0;
        else
            store <= shift;
    end

    always @(posedge cp_sh) begin
        if (!mrn)
            shift <= 0;
        else
            shift <= {shift[6:0], ds};
    end


    /* Instantiation:
    shift_595 new_instance (
        .ds(),
        .oen(),
        .cp_st(),
        .cp_sh(),
        .mrn(),
        .q7p(),
        .q()
    );
    */

endmodule