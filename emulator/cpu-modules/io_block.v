module io_block (
    inout [7:0] main_bus,
    input clk,
    input reset,
    input out_rst,

    output reg [7:0] i_out,
    output reg [7:0] c_out,

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
        if (ctl.sel_x[0] == 1'b0 && ctl.sel_y[0] == 1'b0) begin
            //$display("%d", main_bus);
            i_out <= main_bus;
        end

        if (ctl.sel_x[4] == 1'b0 && ctl.sel_y[0] == 1'b0) begin
            //$write("%c", main_bus);
            c_out <= main_bus;
        end
    end

    always @(posedge out_rst or posedge reset) begin
        i_out <= 8'bx;
        c_out <= 8'bx;
    end


endmodule