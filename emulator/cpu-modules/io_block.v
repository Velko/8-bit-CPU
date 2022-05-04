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

    // unfortunately, Out and COut control lines are allocated so that 2 chips are required
    demux_138 load_mux_l(.e1n(splitter.loadctl[3]), .e2n(1'b0), .e3(1'b1), .a(splitter.loadctl[2:0]));
    demux_138 load_mux_h(.e1n(1'b0), .e2n(1'b0), .e3(splitter.loadctl[3]), .a(splitter.loadctl[2:0]));

    io_control ctl(
        .bus(main_bus),
        .rst(reset),
        .clk(clk),
        .loadn(load_mux_l.y[4]),
        .from_devn(1'b1),
        .to_devn(load_mux_l.y[5])
    );

    //TODO: move to dedicated output modules
    always @(posedge clk) begin
        if (load_mux_l.y[6] == 1'b0 || (ctl.sel_x[0] == 1'b0 && ctl.sel_y[0] == 1'b0)) begin
            //$display("%d", main_bus);
            i_out <= main_bus;
        end

        if (load_mux_h.y[2] == 1'b0 || (ctl.sel_x[4] == 1'b0 && ctl.sel_y[0] == 1'b0)) begin
            //$write("%c", main_bus);
            c_out <= main_bus;
        end
    end

    always @(posedge out_rst) begin
        i_out <= 8'bx;
        c_out <= 8'bx;
    end


endmodule