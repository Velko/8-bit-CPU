module mem_block(
        inout [15:0] abus,
        inout [7:0] mbus,

        input [2:0] addroutctl,
        input [2:0] addrloadctl,

        input [3:0] outctl,
        input [3:0] loadctl,

        input rst,

        input clk,
        input iclk,

        input acincn,
        input acdecn,
        input m_sign,

        output [7:0] iout
);

    //TODO: replace quick boolean operators with proper handling using 74* chips
    address_counter pc(
        .abus(abus),
        .reset(rst),
        .clk(clk),
        .iclk(iclk),
        .outn(addr_out_mux.y[5]),
        .loadn(addr_load_mux.y[5]),
        .cupn(acincn || addr_out_mux.y[5]),
        .cdownn(1'b1)
    );

    i_register ir(
        .bus(mbus),
        .reset(rst),
        .clk(clk),
        .iclk(iclk),
        .loadn(load_mux.y[8]),
        .instr_out(iout)
    );

    memory mem(
        .abus(abus),
        .mbus(mbus),
        .clk(clk),
        .outn(out_mux.y[9]),
        .writen(load_mux.y[9])
    );

    tx_register txl(
        .abus(abus[7:0]),
        .mbus(mbus),
        .reset(rst),
        .clk(clk),
        .iclk(iclk),
        .aoutn(addr_out_mux.y[0]),
        .aloadn(addr_load_mux.y[0]),
        .moutn(out_mux.y[11]),
        .mloadn(load_mux.y[11])
    );

    tx_register txh(
        .abus(abus[15:8]),
        .mbus(mbus),
        .reset(rst),
        .clk(clk),
        .iclk(iclk),
        .aoutn(addr_out_mux.y[0]),
        .aloadn(addr_load_mux.y[0]),
        .moutn(out_mux.y[12]),
        .mloadn(load_mux.y[12])
    );

    address_counter stack(
        .abus(abus),
        .reset(rst),
        .clk(clk),
        .iclk(iclk),
        .outn(addr_out_mux.y[3]),
        .loadn(addr_load_mux.y[3]),
        .cupn(acincn || addr_out_mux.y[3]),
        .cdownn(acdecn || addr_out_mux.y[3])
    );

    address_counter sdp(
        .abus(abus),
        .reset(rst),
        .clk(clk),
        .iclk(iclk),
        .outn(addr_out_mux.y[1]),
        .loadn(addr_load_mux.y[1]),
        .cupn(acincn || addr_out_mux.y[1]),
        .cdownn(acdecn || addr_out_mux.y[1])
    );

    address_calc acalc(
        .abus(abus),
        .mbus(mbus),
        .clk(clk),
        .reset(rst),
        .outn(addr_out_mux.y[2]),
        .loadn(addr_load_mux.y[2]),
        .m_sign(m_sign)
    );

    //TODO: do we need dedicated module or re-using PC is fine?
    address_counter lr(
        .abus(abus),
        .reset(rst),
        .clk(clk),
        .iclk(iclk),
        .outn(addr_out_mux.y[4]),
        .loadn(addr_load_mux.y[4]),
        .cupn(1'b1),
        .cdownn(1'b1)
    );

    demux_138 addr_out_mux(.e1n(1'b0), .e2n(1'b0), .e3(1'b1), .a(addroutctl));
    demux_138 addr_load_mux(.e1n(1'b0), .e2n(1'b0), .e3(1'b1), .a(addrloadctl));

    demux_16 out_mux(.a(outctl));
    demux_16 load_mux(.a(loadctl));

endmodule
