module mem_block(
        inout [15:0] abus,

        input [2:0] addroutctl,
        input [2:0] addrloadctl,

        input rst,
        input rstn,

        input clk,
        input iclk
);
    /* verilator lint_off PINMISSING */
    program_counter pc(.abus(abus), .reset(rst), .resetn(rstn), .clk(clk), .iclk(iclk), .outn(addr_out_mux.y[5]), .loadn(addr_load_mux.y[5]), .count(!addr_out_mux.y[5]));

    demux_138 addr_out_mux(.e1n(1'b0), .e2n(1'b0), .e3(1'b1), .a(addroutctl));
    demux_138 addr_load_mux(.e1n(1'b0), .e2n(1'b0), .e3(1'b1), .a(addrloadctl));

endmodule
