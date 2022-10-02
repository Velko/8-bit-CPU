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

    wire [31:0] cword_out;

    counter_161 cnt(.clk(iclk), .mrn(rstn), .pen(step_resetn), .cep(step_extn), .d(4'b0), .cet(na.y3));

    nand_00p na(.a1(step_extn), .b1(ext.q1), .a2(step_resetn), .b2(na.y1), .a3(ctrlen), .b3(ctrlen), .a4(1'b0), .b4(1'b0));

    dff_74 ext(.cp1(clk), .cp2(iclk), .d1(na.y2), .rd1n(1'b1), .d2(ext.q1n), .sd1n(rstn), .sd2n(1'b1), .rd2n(rstn));

    wire [15:0] rom_addr = {ext.q2, opcode, flags, cnt.q[2:0]};

    rom_async #(.ROMFILE("control_rom0.hex"), .ADDR_BITS(16)) rom0 (
        .cen(1'b0),
        .oen(1'b0),

        .addr(rom_addr),
        .data(cword_out[7:0])
    );

    rom_async #(.ROMFILE("control_rom1.hex"), .ADDR_BITS(16)) rom1 (
        .cen(1'b0),
        .oen(1'b0),

        .addr(rom_addr),
        .data(cword_out[15:8])
    );

    rom_async #(.ROMFILE("control_rom2.hex"), .ADDR_BITS(16)) rom2 (
        .cen(1'b0),
        .oen(1'b0),

        .addr(rom_addr),
        .data(cword_out[23:16])
    );

    rom_async #(.ROMFILE("control_rom3.hex"), .ADDR_BITS(16)) rom3 (
        .cen(1'b0),
        .oen(1'b0),

        .addr(rom_addr),
        .data(cword_out[31:24])
    );

    //always @(posedge iclk) begin
    //    if (ctrlen == 1'b0)
    //        $strobe("x %d %b %b%h", cnt.q, flags, ext.q2, opcode);
    //end

    initial begin
    end

    // ctrlen should be connected to /OE (or /CE) of ROM chips
    assign control_word = ctrlen == 1'b0 ? cword_out : 32'bz;

endmodule