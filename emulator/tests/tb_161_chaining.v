module tb_161_chaining;

    reg clk;
    reg rst;
    reg cep;

    counter_161 c0 ( .clk(clk), .mrn(rst), .cep(cep), .cet(1'b1));
    counter_161 c1 ( .clk(clk), .mrn(rst), .cep(cep), .cet(c0.tc));
    counter_161 c2 ( .clk(clk), .mrn(rst), .cep(cep), .cet(c1.tc));

    always #5 clk = ~clk;

    initial begin
        $display("Chaining 161 counters...");
        $monitor("Q = %h%h%h, tc = %b%b%b", c2.q, c1.q, c0.q, c2.tc, c1.tc, c0.tc);
        $dumpfile("161_chaining.vcd");
        $dumpvars(0, tb_161_chaining);
        clk <= 0;
        cep <= 1;

        // pull reset down initially, release it soon
        rst <= 0;
        #1 rst <= 1;

        #40960 $finish;
    end
endmodule
