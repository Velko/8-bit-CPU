module stack_pointer (
    input outn,
    input loadn,
    input cupn,
    input cdownn,

    input clk,
    input iclk,
    input reset,

    inout [15:0] abus
);

    // pl should follow !clk, when loadn == low
    // cpu should follow !clk, when cup == enabled (low)

    // pl = not(clk) or loadn
    // cpu = not(clk) or cupn
    // cpd = not(clk) or cdownn
    not_04p inv(.a1(clk), .a2(1'b0), .a3(1'b0), .a4(1'b0), .a5(1'b0), .a6(1'b0));
    or_32p ctrl(.a1(1'b0), .b1(1'b0), .a2(inv.y1), .b2(loadn), .a3(inv.y1), .b3(cupn), .a4(inv.y1), .b4(cdownn));

    udcounter_193 cnt_0(.mr(reset), .pl(ctrl.y2), .d(abus[3:0]), .cpu(ctrl.y3), .cpd(ctrl.y4));
    udcounter_193 cnt_1(.mr(reset), .pl(ctrl.y2), .d(abus[7:4]), .cpu(cnt_0.tcu), .cpd(cnt_0.tcd));
    udcounter_193 cnt_2(.mr(reset), .pl(ctrl.y2), .d(abus[11:8]), .cpu(cnt_1.tcu), .cpd(cnt_1.tcd));
    udcounter_193 cnt_3(.mr(reset), .pl(ctrl.y2), .d(abus[15:12]), .cpu(cnt_2.tcu), .cpd(cnt_2.tcd));

    dff_173 outst_0(.mr(reset), .cp(iclk), .e1n(1'b0), .e2n(1'b0), .oe1n(outn), .oe2n(outn), .d(cnt_0.q), .q(abus[3:0]));
    dff_173 outst_1(.mr(reset), .cp(iclk), .e1n(1'b0), .e2n(1'b0), .oe1n(outn), .oe2n(outn), .d(cnt_1.q), .q(abus[7:4]));
    dff_173 outst_2(.mr(reset), .cp(iclk), .e1n(1'b0), .e2n(1'b0), .oe1n(outn), .oe2n(outn), .d(cnt_2.q), .q(abus[11:8]));
    dff_173 outst_3(.mr(reset), .cp(iclk), .e1n(1'b0), .e2n(1'b0), .oe1n(outn), .oe2n(outn), .d(cnt_3.q), .q(abus[15:12]));

endmodule
