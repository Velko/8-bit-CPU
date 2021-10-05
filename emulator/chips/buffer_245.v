module buffer_245 (
    input dir,
    input oen,
    inout [7:0] a,
    inout [7:0] b);

    assign a = !dir && !oen ? b : 'bZ;
    assign b = dir && !oen ? a : 'bZ;

endmodule