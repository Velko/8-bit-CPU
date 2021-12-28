module memory(
    inout [7:0] mbus,
    input [15:0] abus,

    input outn,
    input writen,

    input clk
);

    wire _oe;
    wire _we;
    wire _boe;
    wire _nand_y3;

    ram_62256 mem_l(.addr(abus[14:0]), .csn(abus[15]), .oen(_oe), .wen(_we), .data(outbuf.b));

    // OE = not(LOAD)
    // WE = CLOCK nand OE
    // BOE = not(OUT nand LOAD)

    nand_00p ctrl_sig(
        .a1(writen), .b1(writen), .y1(_oe),
        .a2(clk), .b2(_oe), .y2(_we),
        .a3(outn), .b3(writen), .y3(_nand_y3),
        .a4(_nand_y3), .b4(_nand_y3), .y4(_boe)
    );

    buffer_245 outbuf(.dir(_oe), .oen(_boe), .a(mbus));

endmodule