module tb_gp_register;

    reg outn;
    reg loadn;
    reg loutn;
    reg routn;

    reg clk;
    reg iclk;
    reg reset;

    wire [7:0] bus;

    reg [7:0] data;
    reg wbus;


    gp_register r(.outn(outn), .loadn(loadn), .loutn(loutn), .routn(routn), .clk(clk), .iclk(iclk), .reset(reset), .bus(bus));

    initial begin
        wbus <= 0;
        data <= 8'h3a;

        outn <= 1;
        loadn <= 1;
        loutn <= 1;
        routn <= 1;

        clk <= 0;
        iclk <= 0;

        reset <= 0;

        #1
        $display(bus);

        outn <= 0;
        #1
        $display(bus);

        reset <= 1;
        #1
        $display(bus);
        reset <= 0;

        outn <= 1;
        #1
        $display(bus);


        wbus <= 1;
        #1
        loadn <= 0;
        clk <= 1;
        #1
        clk <= 0;
        wbus <= 0;
        loadn <= 1;
        #1
        $display(bus);
        outn <= 0;
        #1
        $display("Bus: %h", bus);

        $display(r.alu_l);
        loutn <= 0;
        #1
        $display(r.alu_l);
        iclk <= 1;
        #1
        $display(r.alu_l);
        iclk <= 0;


    end

    assign bus = wbus ? data : 8'bZ;

endmodule
