module control_logic(
    input [7:0] opcode,
    input [3:0] flags,
    input step_reset,
    input step_ext,

    input ctrlen,

    input rstn,
    input iclk,

    output [31:0] control_word
);

    reg [31:0] cword_out;

    counter_161 cnt(.clk(iclk), .mrn(rstn), .pen(step_reset), .cep(!step_ext), .d(4'b0), .cet(1'b1));

    //TODO: works, but step_ext signal "pulls the rug" from under itself
    counter_161 ext(.clk(iclk), .mrn(rstn), .pen(step_reset), .cep(step_ext), .d(4'b0), .cet(1'b1));

    always @(opcode or flags or cnt.q or ext.q) begin
        $read_control_rom(cword_out, cnt.q, flags, {ext.q[0], opcode});
        //if (ctrlen == 1'b0)
        //    $display("x %d %b %h", cnt.q, flags, opcode);
    end

    initial begin
        $read_control_rom(cword_out, 0, 0, 0);
    end

    assign control_word = ctrlen == 1'b0 ? cword_out : 32'bz;

endmodule