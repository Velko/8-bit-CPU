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

    dff_374 outst_0(.cp(iclk), .oen(outn), .d(addr[7:0]), .q(abus[7:0]));
    dff_374 outst_1(.cp(iclk), .oen(outn), .d(addr[15:8]), .q(abus[15:8]));

endmodule
