module cmp_85b (
    input [3:0] a,
    input [3:0] b,
    input ilt,
    input ieq,
    input igt,

    output qlt,
    output qeq,
    output qgt
);

    wire main_eq = a == b;
    wire main_lt = a < b;
    wire main_gt = a > b;

    // TODO: LT and GT carry is not fully implemented
    assign qlt = main_lt;
    assign qgt = main_gt;
    assign qeq = main_eq ? ieq : 1'b0;


/* Instantiation:
    cmp_85b new_instance (
        .a(),
        .b(),
        .ilt(),
        .ieq(),
        .igt(),
        .qlt(),
        .qeq(),
        .qgt()
    );
*/

endmodule