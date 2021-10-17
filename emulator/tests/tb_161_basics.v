module tb_161_basics;

    reg clk;
    reg rst;
    reg cep;
    reg cet;
    reg [3:0] d;
    reg pen;

    counter_161 c0 ( .clk(clk), .mrn(rst), .cep(cep), .cet(cet), .d(d), .pen(pen));

    always @(posedge clk or negedge rst) begin
        //$strobe("%t, rst = %b, cep = %b, cet = %b, pen = %b, Q = %h, tc = %b", $time, rst, cep, cet, pen, c0.q, c0.tc);
    end

    initial begin
        $display("74xx161 counter (basics)...");
        $dumpfile("161_basics.vcd");
        $dumpvars(0, tb_161_basics);
        clk <= 0;
        rst <= 0;
        cep <= 1;
        cet <= 1;
        pen <= 1;
        d <= 4'he;

        // release reset, check if 0
        #5 rst <= 1;
        `assert(c0.q, 4'h0)

        // count up to 2
        `tick(clk, 4);
        `assert(c0.q, 4'h2);

        // count while holding reset
        rst <= 0;
        `tick(clk, 4);
        `assert(c0.q, 4'h0);

        // release reset and keep counting
        rst <= 1;
        `tick(clk, 18);
        `assert(c0.q, 4'h9);

        // turn off CEP and check if holds
        cep <= 0;
        `tick(clk, 6);
        `assert(c0.q, 4'h9);

        // re-enable CEP, parallel load
        cep <= 1;
        pen <= 0;
        `tick(clk, 2);
        `assert(c0.q, 4'he);

        // few more ticks, see if holds
        `tick(clk, 6);
        `assert(c0.q, 4'he);


        // disable parallel load, count up to 15, check TC
        pen <= 1;
        `tick(clk, 2);
        `assert(c0.q, 4'hf);
        `assert(c0.tc, 1'b1);

        // disable CET
        cet <= 0;
        #5
        `assert(c0.tc, 1'b0);

        // few more ticks, see if holds
        `tick(clk, 6);
        `assert(c0.q, 4'hf);

        // re-enable counting, wrap-around
        cet <= 1;
        `tick(clk, 2);
        `assert(c0.q, 4'h0);
        `assert(c0.tc, 1'b0);
    end
endmodule
