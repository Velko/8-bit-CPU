module tb_161_chaining;

    reg clk;
    reg rst;
    reg cep;
    reg [11:0] expected;

    counter_161 c0 ( .clk(clk), .mrn(rst), .cep(cep), .cet(1'b1));
    counter_161 c1 ( .clk(clk), .mrn(rst), .cep(cep), .cet(c0.tc));
    counter_161 c2 ( .clk(clk), .mrn(rst), .cep(cep), .cet(c1.tc));

    initial begin
        $display("74xx161 counter (chaining)...");
        // $monitor("Q = %h%h%h, tc = %b%b%b", c2.q, c1.q, c0.q, c2.tc, c1.tc, c0.tc);
        $dumpfile("161_chaining.vcd");
        $dumpvars(0, tb_161_chaining);
        clk <= 0;
        cep <= 1;
        expected <= 0;

        // pull reset down initially, release it soon
        rst <= 0;
        #1
        rst <= 1;

        repeat (4096) begin
            #5
            `assert({c2.q, c1.q, c0.q}, expected);
            clk <= 0;
            #5
            clk <= 1;
            expected <= expected + 1;
        end
    end
endmodule
