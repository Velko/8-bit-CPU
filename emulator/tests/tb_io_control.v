module tb_io_control;

    wire [7:0] bus;
    reg [7:0] data;
    reg wbus;

    reg rst;
    reg clk;
    reg loadn;
    reg from_devn;
    reg to_devn;

    io_control controller(
        .bus(bus),
        .rst(rst),
        .clk(clk),
        .loadn(loadn),
        .from_devn(from_devn),
        .to_devn(to_devn)
    );

    initial begin
        $display("I/O controller...");

        wbus <= 0;
        data <= 8'h0;
        rst <= 1;
        clk <= 0;
        loadn <= 1;
        from_devn <= 1;
        to_devn <= 1;

        #1 rst <= 0;

        // load some addr
        data <= 8'h34;
        wbus <= 1;
        loadn <= 0;

        #1
        `tick(clk, 2);

        `assert(controller.sel_x, 8'b11101111);
        `assert(controller.sel_y, 8'b10111111);

    end

    assign bus = wbus ? data : 8'bZ;

endmodule