module program_counter (
    input outn,
    input loadn,
    input count,

    input clk,
    input iclk,
    input reset,
    input resetn,

    inout [15:0] abus
);
    wire [15:0] addr;

    counter_161 cnt_0(.clk(clk), .mrn(resetn), .pen(loadn), .cep(count), .d(abus[3:0]),  .q(addr[3:0]),   .cet(1'b1));
    counter_161 cnt_1(.clk(clk), .mrn(resetn), .pen(loadn), .cep(count), .d(abus[7:4]),  .q(addr[7:4]),   .cet(cnt_0.tc));
    counter_161 cnt_2(.clk(clk), .mrn(resetn), .pen(loadn), .cep(count), .d(abus[11:8]), .q(addr[11:8]),  .cet(cnt_1.tc));
    counter_161 cnt_3(.clk(clk), .mrn(resetn), .pen(loadn), .cep(count), .d(abus[15:12]),.q(addr[15:12]), .cet(cnt_2.tc));

    dff_173 outst_0(.mr(reset), .cp(iclk), .e1n(1'b0), .e2n(1'b0), .oe1n(outn), .oe2n(outn), .d(addr[3:0]),   .q(abus[3:0]));
    dff_173 outst_1(.mr(reset), .cp(iclk), .e1n(1'b0), .e2n(1'b0), .oe1n(outn), .oe2n(outn), .d(addr[7:4]),   .q(abus[7:4]));
    dff_173 outst_2(.mr(reset), .cp(iclk), .e1n(1'b0), .e2n(1'b0), .oe1n(outn), .oe2n(outn), .d(addr[11:8]),  .q(abus[11:8]));
    dff_173 outst_3(.mr(reset), .cp(iclk), .e1n(1'b0), .e2n(1'b0), .oe1n(outn), .oe2n(outn), .d(addr[15:12]), .q(abus[15:12]));

endmodule
