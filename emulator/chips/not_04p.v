module not_04p (
    input a1,
    output y1,

    input a2,
    output y2,

    input a3,
    output y3,

    input a4,
    output y4,

    input a5,
    output y5,

    input a6,
    output y6);

    assign y1 = !a1;
    assign y2 = !a2;
    assign y3 = !a3;
    assign y4 = !a4;
    assign y5 = !a5;
    assign y6 = !a6;

    /* Instantiation:
    not_04p new_instance (
        .a1(),
        .y1(),

        .a2(),
        .y2(),

        .a3(),
        .y3(),

        .a4(),
        .y4(),

        .a5(),
        .y5(),

        .a6(),
        .y6()
    );
    */
endmodule
