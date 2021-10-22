module tb_cpu;

    reg [7:0] data;
    reg fdata;
    wire [7:0] main_bus;

    reg rst;
    reg clk;
    reg iclk;

    reg [31:0] control_word;

    cpu processor(.main_bus(main_bus), .rst(rst), .clk(clk), .iclk(iclk), .control_word(control_word));

    initial begin
        fdata <= 0;

        // clear, reset
        rst <= 1;
        clk <= 0;
        iclk <= 0;
        control_word <= 32'b00111011111110000011111111001111;
        #1
        rst <= 0;

        // Load A
        data <= 8'd24;
        fdata <= 1;
        control_word <= 32'b00111011111110000011000011001111;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);

        // Load B
        data <= 8'd18;
        control_word <= 32'b00111011111110000011000111001111;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);

        // Add A to B
        fdata <= 0;
        control_word <= 32'b00111011111001000011000010000010;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);

        // Output A to Bus
        control_word <= 32'b00111011111110000011111111000000;
        #1
        `assert(main_bus, 8'd42);
        $display("%d", main_bus);

    end

    assign main_bus = fdata ? data : 8'bz;

endmodule