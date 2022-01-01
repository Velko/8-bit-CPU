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
        input iclk,

        input spinc,
        input spdec,

        output [7:0] iout
);
    program_counter pc(.abus(abus), .reset(rst), .resetn(rstn), .clk(clk), .iclk(iclk), .outn(addr_out_mux.y[5]), .loadn(addr_load_mux.y[5]), .count(!addr_out_mux.y[5]));

    i_register ir(.bus(mbus), .reset(rst), .clk(clk), .iclk(iclk), .loadn(load_mux_l.y[4]), .instr_out(iout));

    memory mem(.abus(abus), .mbus(mbus), .clk(clk), .outn(out_mux_l.y[3]), .writen(load_mux_l.y[3]));

    tx_register txl(.abus(abus[7:0]), .mbus(mbus), .reset(rst), .clk(clk), .iclk(iclk), .aoutn(addr_out_mux.y[0]), .aloadn(addr_load_mux.y[0]), .moutn(out_mux_h.y[3]), .mloadn(load_mux_h.y[3]));
    tx_register txh(.abus(abus[15:8]), .mbus(mbus), .reset(rst), .clk(clk), .iclk(iclk), .aoutn(addr_out_mux.y[0]), .aloadn(addr_load_mux.y[0]), .moutn(out_mux_l.y[5]), .mloadn(load_mux_l.y[5]));

    stack_pointer stack(.abus(abus), .reset(rst), .clk(clk), .iclk(iclk), .outn(addr_out_mux.y[3]), .loadn(addr_load_mux.y[3]), .cupn(spinc), .cdownn(spdec));

    //TODO: do we need dedicated module or re-using PC is fine?
    program_counter lr(.abus(abus), .reset(rst), .resetn(rstn), .clk(clk), .iclk(iclk), .outn(addr_out_mux.y[4]), .loadn(addr_load_mux.y[4]), .count(1'b0));

    demux_138 addr_out_mux(.e1n(1'b0), .e2n(1'b0), .e3(1'b1), .a(addroutctl));
    demux_138 addr_load_mux(.e1n(1'b0), .e2n(1'b0), .e3(1'b1), .a(addrloadctl));

    //TODO: move signals to minimize mux chip count?
    demux_138 out_mux_l(.e1n(outctl[3]), .e2n(1'b0), .e3(1'b1), .a(outctl[2:0]));
    demux_138 load_mux_l(.e1n(loadctl[3]), .e2n(1'b0), .e3(1'b1), .a(loadctl[2:0]));
    demux_138 out_mux_h(.e1n(1'b0), .e2n(1'b0), .e3(outctl[3]), .a(outctl[2:0]));
    demux_138 load_mux_h(.e1n(1'b0), .e2n(1'b0), .e3(loadctl[3]), .a(loadctl[2:0]));

endmodule
