module const_arg (
    input [7:0] value,


    input loutn,
    input routn,

    output [7:0] alu_l,
    output [7:0] alu_r);

    buffer_245 left_buf(
        .oen(loutn),
        .dir(1'b1),
        .a(value),
        .b(alu_l)
    );

    buffer_245 right_buf(
        .oen(routn),
        .dir(1'b1),
        .a(value),
        .b(alu_r)
    );

endmodule
