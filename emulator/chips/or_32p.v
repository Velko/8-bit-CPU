module or_32p (
    input a1,
    input b1,
    output y1,

    input a2,
    input b2,
    output y2,

    input a3,
    input b3,
    output y3,

    input a4,
    input b4,
    output y4);

    assign y1 = a1 | b1;
    assign y2 = a2 | b2;
    assign y3 = a3 | b3;
    assign y4 = a4 | b4;

endmodule