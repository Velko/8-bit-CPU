module xor_86b (
    input [3:0] a,
    input [3:0] b,
    output[3:0] y);

    assign y = a ^ b;

    /* Instantiation:
    xor_86b new_instance (
        .a(),
        .b(),
        .y()
    );
    */
endmodule
