module tb_alu_block;

    reg reset;
    reg [2:0] outctl;
    reg [2:0] loadctl;
    reg clk;
    reg iclk;
    reg alt;
    reg cfn;

    reg [7:0] data;
    reg fdata;
    wire [7:0] main_bus;

    alu_block ab(.main_bus(main_bus), .rst(reset), .outctl(outctl), .loadctl(loadctl), .clk(clk), .iclk(iclk), .alt(alt), .calcfn(cfn));

    initial begin
        fdata <= 0;

        outctl <= 7;
        loadctl <= 7;
        clk <= 0;
        iclk <= 0;
        alt <= 0;
        cfn <= 1;

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
        #1
        `tick(clk, 2);
        `tick(iclk, 2);

        // read A
        outctl <= 0;
        loadctl <= 7;
        #1
        $display("%d %h", main_bus, ab.fout);

    end

    assign main_bus = fdata ? data : 8'bz;

endmodule