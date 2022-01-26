module dff_74(
    input rd1n,
    input d1,
    input cp1,
    input sd1n,
    output reg q1,
    output q1n,

    input rd2n,
    input d2,
    input cp2,
    input sd2n,
    output reg q2,
    output q2n);

    // general case - unit1
    always @(posedge cp1 or negedge rd1n or negedge sd1n) begin
        if (!sd1n)
            q1 <= 1'b1;
        else if (!rd1n)
            q1 <= 1'b0;
        else
            q1 <= d1;
    end

    // when exiting SET==RESET==LOW state
    always @(posedge sd1n) begin
        if (!rd1n)
            q1 <= 1'b0;
    end

    // H if SET==RESET==LOW, opposite of Q otherwise
    assign q1n = !rd1n && !sd1n ? 1'b1 : !q1;

    // general case - unit2
    always @(posedge cp2 or negedge rd2n or negedge sd2n) begin
        if (!sd2n)
            q2 <= 1'b1;
        else if (!rd2n)
            q2 <= 1'b0;
        else
            q2 <= d2;
    end

    // when exiting SET==RESET==LOW state
    always @(posedge sd2n) begin
        if (!rd2n)
            q2 <= 1'b0;
    end

    // H if SET==RESET==LOW, opposite of Q otherwise
    assign q2n = !rd2n && !sd2n ? 1'b1 : !q2;


endmodule