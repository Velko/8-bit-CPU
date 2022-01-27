module control_logic(
    input [7:0] opcode,
    input [3:0] flags,
    input step_resetn,
    input step_extn,

    input ctrlen,

    input rstn,
    input clk,
    input iclk,

    output [31:0] control_word
);

    reg [31:0] cword_out;

    counter_161 cnt(.clk(iclk), .mrn(rstn), .pen(step_resetn), .cep(step_extn), .d(4'b0), .cet(!ctrlen));

    nand_00p na(.a1(step_extn), .b1(ext.q1), .a2(step_resetn), .b2(na.y1), .a3(1'b0), .b3(1'b0), .a4(1'b0), .b4(1'b0));

    dff_74 ext(.cp1(clk), .cp2(iclk), .d1(na.y2), .rd1n(1'b1), .d2(ext.q1n), .sd1n(rstn), .sd2n(1'b1), .rd2n(rstn));

    always @(opcode or flags or cnt.q or ext.q2) begin
        $read_control_rom(cword_out, cnt.q, flags, {ext.q2, opcode});
    end

    //always @(posedge iclk) begin
    //    if (ctrlen == 1'b0)
    //        $strobe("x %d %b %b%h", cnt.q, flags, ext.q2, opcode);
    //end

    initial begin
        $read_control_rom(cword_out, 0, 0, 0);
    end

    assign control_word = ctrlen == 1'b0 ? cword_out : 32'bz;

endmodule