module tb_cpu;

    reg [7:0] data;
    reg fdata;
    wire [7:0] main_bus;

    reg [15:0] addr;
    reg faddr;
    wire [15:0] addr_bus;


    reg rst;
    reg clk;
    reg iclk;

    reg [31:0] control_word;
    wire [31:0] wcontrol_word;

    reg out_rst;

    cpu processor(
        .main_bus(main_bus),
        .addr_bus(addr_bus),
        .rst(rst),
        .clk(clk),
        .iclk(iclk),
        .control_word(wcontrol_word),
        .ctrlen(1'b1),
        .out_rst(out_rst)
    );

    initial begin
        $display("Whole CPU...");
        fdata <= 0;
        out_rst <= 0;

        // clear, reset
        rst <= 1;
        clk <= 0;
        iclk <= 0;
        control_word <= 32'b00010111111111110101100011111111;
        #1
        rst <= 0;

        // Load A
        data <= 8'd24;
        fdata <= 1;
        control_word <= 32'b00010111111111110101100000001111;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);

        // Load B
        data <= 8'd18;
        control_word <= 32'b00010111111111110101100000011111;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);

        // Add A to B
        fdata <= 0;
        control_word <= 32'b00010111111111110100010000000101;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);

        // Output A to Bus
        control_word <= 32'b00010111111111110101100011110000;
        #1
        `assert(main_bus, 8'd42);
        $display("%d", main_bus);

        // Write something in RAM
        fdata <= 1;
        data <= 8'h54;
        faddr <= 1;
        addr <= 16'h1234;

        control_word <=32'b00010111111111110101100010011111;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);

        // Read from different addr
        fdata <= 0;
        addr <= 16'h1235;
        control_word <=32'b00010111111111110101100011111001;
        #1
        `assert(main_bus, 8'bx);

        // Read back from written addr
        addr <= 16'h1234;
        #1
        `assert(main_bus, 8'h54);

    end

    assign main_bus = fdata ? data : 8'bz;
    assign addr_bus = faddr ? addr : 16'bz;
    assign wcontrol_word = control_word;

endmodule