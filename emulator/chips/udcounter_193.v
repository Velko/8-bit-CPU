module udcounter_193 (
    input cpd,
    input cpu,
    input pl,
    input mr,
    input [3:0] d,
    output reg [3:0] q,
    output tcu,
    output tcd);

    // reset and parallel load
    always @(mr or pl) begin
        if (mr) begin
            q <= 0;
        end
        else if (!pl) begin
            q <= d;
        end
    end

    // count up
    always @(posedge cpu) begin
        if (!mr && pl && cpd) begin
            q <= q + 1;
        end
    end

    // count down
    always @(posedge cpd) begin
        if (!mr && pl && cpu)
        begin
            q <= q - 1;
        end
    end

    // async parallel load
    always @(d) begin
        if (!mr && !pl) begin
            q <= d;
        end
    end

    assign tcu = q == 4'b1111 ? cpu : 1'b1;
    assign tcd = q == 4'b0000 ? cpd : 1'b1;

    /* Instantiation:
    udcounter_193 new_instance (
        .cpd(),
        .cpu(),
        .pl(),
        .mr(),
        .d(),
        .q(),
        .tcu(),
        .tcd()
    );
    */
endmodule
