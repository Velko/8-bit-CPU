module tb_161_basics;

    reg clk;
    reg rst;
    reg cep;
    reg cet;
    reg [3:0] d;
    reg pen;

    counter_161 c0 ( .clk(clk), .mrn(rst), .cep(cep), .cet(cet), .d(d), .pen(pen));

    always #5 clk = ~clk;

    initial begin
        $display("Checking counter...");
        $monitor("At %t, rst = %b, cep = %b, cet = %b, pen = %b, Q = %h, tc = %b", $time, rst, cep, cet, pen, c0.q, c0.tc);
        $dumpfile("161_basics.vcd");
        $dumpvars(0, tb_161_basics);
        clk <= 0;
        rst <= 0;
        cep <= 1;
        cet <= 1;
        pen <= 1;
        d <= 4'he;

        #1 rst <= 1;

        #16 rst <= 0;
        #10 rst <= 1;

        #20 cep <= 0;
        #20 cep <= 1;

        #20 cet <= 0;
        #20 cet <= 1;


        #30 pen <= 0;
        #20 pen <= 1;

        #200 $finish;
    end
endmodule
