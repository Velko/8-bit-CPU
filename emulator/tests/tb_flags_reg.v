module tb_flags_reg;

    reg [7:0] data;
    wire [7:0] bus;
    reg wbus;

    reg calcn;

    reg clk;
    reg iclk;
    reg reset;

    reg vin;
    reg cin;

    integer i;

    flags_reg flags(.calcn(calcn), .clk(clk), .iclk(iclk), .reset(reset), .bus(bus), .vin(vin), .cin(cin));

    initial begin
        $display("Flags register module...");

        wbus <= 1;

        calcn <= 1;
        reset <= 0;
        clk <= 0;
        iclk <= 0;
        vin <= 1'bz;
        cin <= 1'bz;

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

        // check oVerflow input
        vin <= 1;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);
        `assert(flags.fout[3], 1'b1);

        // release the pin, see if it holds
        vin <= 1'bz;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);
        `assert(flags.fout[3], 1'b1);

        // drive low
        vin <= 0;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);
        `assert(flags.fout[3], 1'b0);

        // release the pin, see if it holds
        vin <= 1'bz;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);
        `assert(flags.fout[3], 1'b0);

        // same with Carry input
        cin <= 1;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);
        `assert(flags.fout[2], 1'b1);

        // release the pin, see if it holds
        cin <= 1'bz;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);
        `assert(flags.fout[2], 1'b1);

        // drive low
        cin <= 0;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);
        `assert(flags.fout[2], 1'b0);

        // release the pin, see if it holds
        cin <= 1'bz;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);
        `assert(flags.fout[2], 1'b0);

    end

    assign bus = wbus ? data : 8'bZ;

endmodule