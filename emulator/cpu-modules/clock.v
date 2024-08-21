module clock(
    input auton,
    input m,

    output clk,
    output iclk);

    reg clk_free;
    reg clk_scan;

    reg int_reset;

    nand_00p na(.a1(clk_free), .b1(dff_sel.q1), .a2(dff_sel.q1n), .b2(xr.y1), .a3(na.y1), .b3(na.y2), .a4(na.y3), .b4(na.y3));
    dff_74 dff_sel(.sd1n(auton), .cp1(no.y4), .rd1n(int_reset), .d1(dff_man.q2n),
                   .sd2n(int_reset), .rd2n(1'b1), .cp2(na.y4), .d2(dff_sel.q2n));
    dff_74 dff_man(.sd1n(1'b1), .rd1n(int_reset), .sd2n(1'b1), .rd2n(int_reset), .cp1(clk_scan), .cp2(clk_scan),
        .d1(m), .d2(dff_man.q1));
    xor_86p xr(.a1(dff_man.q1), .b1(dff_man.q2),
               .a2(1'b0), .a3(1'b0), .a4(1'b0), .b2(1'b0), .b3(1'b0), .b4(1'b0));
    nor_02p no(.a1(na.y4), .a2(na.y4), .b1(dff_sel.q2), .b2(dff_sel.q2n), .a4(no.y2), .b4(no.y2), .a3(1'b0), .b3(1'b0), .y1(iclk), .y2(clk));

    initial begin
        clk_free <= 0;
        clk_scan <= 0;
        int_reset <= 0;
        #1
        int_reset <= 1;

    end

    always #2 clk_free = ~clk_free;
    always #5 clk_scan = ~clk_scan;

endmodule
