module tb_alu_block;

    reg reset;
    reg aoutn;
    reg boutn;
    reg soutn;
    reg aloadn;
    reg bloadn;
    reg clk;
    reg iclk;
    reg alt;
    reg cfn;

    reg [7:0] data;
    reg fdata;
    wire [7:0] main_bus;

    alu_block ab(.main_bus(main_bus), .reset(reset), .a_outn(aoutn), .b_outn(boutn), .addsub_outn(soutn), .a_loadn(aloadn), .b_loadn(bloadn), .clk(clk), .iclk(iclk), .alt(alt), .calcfn(cfn));

    initial begin
        fdata <= 0;

        aoutn <= 1;
        boutn <= 1;
        soutn <= 1;
        aloadn <= 1;
        bloadn <= 1;
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
        aloadn <= 0;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);

        // load into B
        aloadn <= 1;
        bloadn <= 0;
        data <= 8'd18;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);

        // add and load into A
        bloadn <= 1;
        fdata <= 0;
        soutn <= 0;
        aloadn <= 0;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);

        // read A
        soutn <= 1;
        aloadn <= 1;
        aoutn <= 0;
        #1
        $display("%d", main_bus);

    end

    assign main_bus = fdata ? data : 8'bz;

endmodule