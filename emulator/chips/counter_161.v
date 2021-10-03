module counter_161 (
    input clk,
    input mrn,
    input cep,
    input cet,
    input pen,
    input [3:0] d,
    output reg [3:0] q,
    output tc);

    always @ (posedge clk or negedge mrn) begin
        if (!mrn)
            q <= 0;
        else if (!pen)
            q <= d;
        else if (cep && cet)
            q <= q + 1;

    end
    assign tc = q == 4'b1111 && cet;

endmodule
