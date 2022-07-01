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

    always @(posedge clk) begin
        if (ctl.sel_x[4] == 1'b0 && ctl.sel_y[0] == 1'b0) begin
            if (main_bus == "\n") begin
                $swrite(out_fmt, "#FOUT#\\n");
            end
            else begin
                $sformat(out_fmt, "#FOUT#%c", main_bus);
            end
        end

        if (ctl.sel_x[0] == 1'b0 && ctl.sel_y[0] == 1'b0) begin
            $sformat(out_fmt, "#FOUT#%d\\n", main_bus);
        end

    end

    always @(posedge out_rst or posedge reset) begin
        out_fmt <= 160'bx;
    end


endmodule
