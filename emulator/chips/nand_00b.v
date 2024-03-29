module nand_00b (
    input [3:0] a,
    input [3:0] b,
    output[3:0] y);

    assign y = ~(a & b);

    /* Instantiation:
    nand_00b new_instance (
        .a(),
        .b(),
        .y()
    );
    */
endmodule
