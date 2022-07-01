module io_block (
    inout [7:0] main_bus,
    input clk,
    input reset,
    input out_rst,

    output reg [159:0] out_fmt,

    input [3:0] outctl,
    input [3:0] loadctl
);

    demux_138 load_mux_l(.e1n(splitter.loadctl[3]), .e2n(1'b0), .e3(1'b1), .a(splitter.loadctl[2:0]));

    io_control ctl(
        .bus(main_bus),
        .rst(reset),
        .clk(clk),
        .loadn(load_mux_l.y[4]),
        .from_devn(1'b1),
        .to_devn(load_mux_l.y[5])
    );

    display_num ndisp(
        .main_bus(main_bus),
        .clk(clk),
        .load_val(ctl.sel_x[0] == 1'b0 && ctl.sel_y[0] == 1'b0),
        .load_mode(ctl.sel_x[1] == 1'b0 && ctl.sel_y[0] == 1'b0),
        .reset(reset)
    );

    display_char cdisp(
        .main_bus(main_bus),
        .clk(clk),
        .load_val(ctl.sel_x[4] == 1'b0 && ctl.sel_y[0] == 1'b0)
    );

    always @(ndisp.out_fmt) begin
        out_fmt <= ndisp.out_fmt;
    end

    always @(cdisp.out_fmt) begin
        out_fmt <= cdisp.out_fmt;
    end

    always @(posedge out_rst or posedge reset) begin
        out_fmt <= 160'bx;
    end

endmodule
