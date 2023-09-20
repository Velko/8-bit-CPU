module io_block (
    inout [7:0] main_bus,
    input clk,
    input reset,

    input [3:0] outctl,
    input [3:0] loadctl
);

    wire [7:0] io_bus;
    wire to_devn;
    wire from_devn;

    assign to_devn = load_mux.y[5];
    assign from_devn = out_mux.y[8];

    demux_16 load_mux(.a(loadctl));
    demux_16 out_mux(.a(outctl));

    io_control ctl(
        .main_bus(main_bus),
        .rst(reset),
        .clk(clk),
        .loadn(load_mux.y[4]),
        .from_devn(from_devn),
        .to_devn(to_devn),
        .io_bus(io_bus)
    );

    display_num ndisp(
        .main_bus(io_bus),
        .clk(clk),
        .load_val(ctl.sel_x[0] == 1'b0 && ctl.sel_y[0] == 1'b0),
        .load_mode(ctl.sel_x[1] == 1'b0 && ctl.sel_y[0] == 1'b0),
        .reset(reset)
    );

    display_char cdisp(
        .main_bus(io_bus),
        .clk(clk),
        .load_val(ctl.sel_x[4] == 1'b0 && ctl.sel_y[0] == 1'b0)
    );


    display_lcd lcd(
        .io_bus(io_bus),
        .enable(!ctl.sel_y[1] && (clk || !from_devn)),
        .rnw(to_devn),
        .rs(ctl.sel_x[1])
    );

endmodule
