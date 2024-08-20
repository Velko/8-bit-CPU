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

    wire [15:0] addr;
    wire p_loadn;
    wire cpu;
    wire cpd;

    // pl should follow !clk, when loadn == low
    // cpu should follow !clk, when cup == enabled (low)

    // pl = not(clk) or loadn
    // cpu = not(clk) or cupn
    // cpd = not(clk) or cdownn
    not_04p inv(
        .a1(clk),
         .a2(1'b0), .a3(1'b0), .a4(1'b0), .a5(1'b0), .a6(1'b0));

    or_32p ctrl(
        .a1(1'b0), .b1(1'b0),
        .a2(inv.y1), .b2(loadn), .y2(p_loadn),
        .a3(inv.y1), .b3(cupn), .y3(cpu),
        .a4(inv.y1), .b4(cdownn), .y4(cpd));

    udcounter_193 cnt_0(
        .mr(reset),
        .pl(p_loadn),
        .d(abus[3:0]),
        .q(addr[3:0]),
        .cpu(cpu),
        .cpd(cpd));

    udcounter_193 cnt_1(
        .mr(reset),
        .pl(p_loadn),
        .d(abus[7:4]),
        .q(addr[7:4]),
        .cpu(cnt_0.tcu),
        .cpd(cnt_0.tcd));

    udcounter_193 cnt_2(
        .mr(reset),
        .pl(p_loadn),
        .d(abus[11:8]),
        .q(addr[11:8]),
        .cpu(cnt_1.tcu),
        .cpd(cnt_1.tcd));

    udcounter_193 cnt_3(
        .mr(reset),
        .pl(p_loadn),
        .d(abus[15:12]),
        .q(addr[15:12]),
        .cpu(cnt_2.tcu),
        .cpd(cnt_2.tcd));

    dff_374 outst_0(
        .cp(iclk),
        .oen(outn),
        .d(addr[7:0]),
        .q(abus[7:0]));

    dff_374 outst_1(
        .cp(iclk),
        .oen(outn),
        .d(addr[15:8]),
        .q(abus[15:8]));

endmodule
