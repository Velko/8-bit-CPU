module tb_alu_block;

    reg reset;
    reg [3:0] outctl;
    reg [3:0] loadctl;
    reg [1:0] arg_l;
    reg [2:0] arg_r;

    reg clk;
    reg iclk;
    reg alt;
    reg cfn;
    reg cin;

    reg [7:0] data;
    reg fdata;
    wire [7:0] main_bus;

    alu_block ab(.main_bus(main_bus), .rst(reset), .outctl(outctl), .loadctl(loadctl), .clk(clk), .iclk(iclk), .alt(alt), .calcfn(cfn), .arg_l(arg_l), .arg_r(arg_r), .cin(cin));

    initial begin
        fdata <= 0;

        outctl <= 15;
        loadctl <= 15;
        clk <= 0;
        iclk <= 0;
        alt <= 0;
        cfn <= 1;
        arg_l <= 0;
        arg_r <= 6;
        cin <= 0;

        reset <= 1;
        #1
        reset <= 0;

        // simple addition - load into A
        data <= 8'd24;
        fdata <= 1;
        loadctl <= 0;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);

        // load into B
        loadctl <= 1;
        cfn <= 0;
        data <= 8'd18;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);

        // add and load into A
        fdata <= 0;
        outctl <= 2;
        loadctl <= 0;
        arg_r <= 1;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);
        loadctl <= 15;
        arg_r <= 6;

        // read A
        outctl <= 0;
        loadctl <= 15;
        #1
        $display("%d %h", main_bus, ab.fout);
        `assert(main_bus, 8'd42);
        `assert(ab.fout, 4'b000);

        // load B for wrap-around
        fdata <= 1;
        outctl <= 15;
        loadctl <= 1;
        data <= 256 - 42;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);

        // add and load into A
        fdata <= 0;
        outctl <= 2;
        loadctl <= 0;
        arg_r <= 1;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);
        loadctl <= 15;
        arg_r <= 6;

        outctl <= 0;
        #1
        $display("%d %h", main_bus, ab.fout);
        `assert(main_bus, 8'd0);
        `assert(ab.fout, 4'b0110);

    end

    assign main_bus = fdata ? data : 8'bz;

endmodule