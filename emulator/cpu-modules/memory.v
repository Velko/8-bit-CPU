module memory(
    inout [7:0] mbus,
    inout [15:0] abus,

    input outn,
    input writen,

    input clk
);

    wire _oe;
    wire _we;
    wire _boe;
    wire _nand_y3;
    wire [7:0] _mem_data;

    //TODO: should use discrete logic for CS calculations
    wire rom_sel = abus >= 16'hE000; //upper 8 KiB
    wire ram_l_sel = !abus[15];
    wire ram_h_sel = !rom_sel && abus[15];

    assign (pull0, pull1) abus = 16'hE000; // pull address bus to reset value (start of ROM)

    ram_62256 mem_l(
        .addr(abus[14:0]),
        .csn(!ram_l_sel),
        .oen(_oe),
        .wen(_we),
        .data(_mem_data)
    );

    ram_62256 mem_h(
        .addr(abus[14:0]),
        .csn(!ram_h_sel),
        .oen(_oe),
        .wen(_we),
        .data(_mem_data)
    );

    rom_async #(.ROMFILE("bios.hex"), .ADDR_BITS(13)) bios (
        .addr(abus[12:0]),
        .cen(!rom_sel),
        .oen(_oe),
        .data(_mem_data)
    );

    // OE = not(LOAD)
    // WE = CLOCK nand OE
    // BOE = not(OUT nand LOAD)

    nand_00p ctrl_sig(
        .a1(writen), .b1(writen), .y1(_oe),
        .a2(clk), .b2(_oe), .y2(_we),
        .a3(outn), .b3(writen), .y3(_nand_y3),
        .a4(_nand_y3), .b4(_nand_y3), .y4(_boe)
    );

    buffer_245 outbuf(.dir(_oe), .oen(_boe), .a(mbus), .b(_mem_data));

    always @(posedge clk) begin
        if (outn == 1'b0 && ^abus === 1'bX)
            $error("Attempting to read invalid address %b", abus);

        if (writen == 1'b0 && ^abus === 1'bX)
            $error("Attempting to write at invalid address %b", abus);

        if (writen == 1'b0 && ^mbus === 1'bX)
            $error("Attempting to write invalid data %b", mbus);
    end

endmodule