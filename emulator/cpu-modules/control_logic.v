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

    counter_161 cnt(.clk(iclk), .mrn(rstn), .pen(step_reset), .cep(1'b1), .d(4'b0), .cet(1'b1));

    always @(opcode or flags or cnt.q) begin
        $read_control_rom(cword_out, cnt.q, flags, opcode);
        //if (ctrlen == 1'b0)
        //    $display("x %d %b %h", cnt.q, flags, opcode);
    end

    initial begin
        $read_control_rom(cword_out, 0, 0, 0);
    end

    assign control_word = ctrlen == 1'b0 ? cword_out : 32'bz;

endmodule