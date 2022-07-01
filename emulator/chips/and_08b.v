module and_08b (
    input [3:0] a,
    input [3:0] b,
    output[3:0] y);

    assign y = a & b;

    /* Instantiation:
    and_08b new_instance (
        .a(),
        .b(),
        .y()
    );
    */
endmodule
