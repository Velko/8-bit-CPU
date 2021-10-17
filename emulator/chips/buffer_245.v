module buffer_245 (
    input dir,
    input oen,
    inout [7:0] a,
    inout [7:0] b);

    reg [7:0] temp;

    always @ (dir or a or b) begin
        temp = dir ? a : b;
    end

    assign a = !dir && !oen ? temp : 8'bZ;
    assign b = dir && !oen ? temp : 8'bZ;

endmodule
