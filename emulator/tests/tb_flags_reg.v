module tb_flags_reg;

    reg [7:0] data;
    wire [7:0] bus;
    reg wbus;

    reg calcn;

    reg clk;
    reg iclk;
    reg reset;

    integer i;

    flags_reg flags(.calcn(calcn), .clk(clk), .iclk(iclk), .reset(reset), .bus(bus));

    initial begin
        $display("Flags register module...");

        wbus <= 1;

        calcn <= 1;
        reset <= 0;
        clk <= 0;
        iclk <= 0;

        #1
        `assert(flags.fout, 4'bx);

        // reset
        reset <= 1;
        #1
        `assert(flags.fout, 4'h0);


        // load negative
        reset <= 0;
        data <= 8'h80;
        calcn <= 0;
        #1
        `tick(clk, 2);
        `assert(flags.fout, 4'h0);

        // output should change on iclk
        `tick(iclk, 2);
        `assert(flags.fout[0], 1'b1);
        `assert(flags.fout[1], 1'b0);

        // load zero
        data <= 8'h00;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);
        `assert(flags.fout[0], 1'b0);
        `assert(flags.fout[1], 1'b1);

        // Z not set if one bit is set
        for (i = 0; i < 8; i = i + 1) begin
            data <= 1 << i;
            #1
            `tick(clk, 2);
            `tick(iclk, 2);
            `assert(flags.fout[1], 1'b0);
        end

    end

    assign bus = wbus ? data : 8'bZ;

endmodule