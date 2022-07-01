module adder_283 (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] s,
    output cout);

    assign {cout, s} = a + b + {4'b0000, cin};

    /* Instantiation:
    adder_283 new_instance (
        .a(),
        .b(),
        .cin(),
        .s(),
        .cout()
    );
    */
endmodule
