module mem_block(
        inout [15:0] abus,
        inout [7:0] mbus,

        input [2:0] addroutctl,
        input [2:0] addrloadctl,

        input [3:0] outctl,
        input [3:0] loadctl,

        input rst,
        input rstn,

        input clk,
        input iclk
);
    program_counter pc(.abus(abus), .reset(rst), .resetn(rstn), .clk(clk), .iclk(iclk), .outn(addr_out_mux.y[5]), .loadn(addr_load_mux.y[5]), .count(!addr_out_mux.y[5]));

    memory mem(.abus(abus), .mbus(mbus), .clk(clk), .outn(out_mux_l.y[3]), .writen(load_mux_l.y[3]));

    demux_138 addr_out_mux(.e1n(1'b0), .e2n(1'b0), .e3(1'b1), .a(addroutctl));
    demux_138 addr_load_mux(.e1n(1'b0), .e2n(1'b0), .e3(1'b1), .a(addrloadctl));

    //TODO: move signals to minimize mux chip count?
    demux_138 out_mux_l(.e1n(outctl[3]), .e2n(1'b0), .e3(1'b1), .a(outctl[2:0]));
    demux_138 load_mux_l(.e1n(loadctl[3]), .e2n(1'b0), .e3(1'b1), .a(loadctl[2:0]));

endmodule
