module tb_161_basics;

    reg clk;
    reg rst;
    reg cep;
    reg cet;
    reg [3:0] d;
    reg pen;

    counter_161 c0 ( .clk(clk), .mrn(rst), .cep(cep), .cet(cet), .d(d), .pen(pen));

    always #5 clk = ~clk;

    always @(posedge clk or negedge rst) begin
        $strobe("%t, rst = %b, cep = %b, cet = %b, pen = %b, Q = %h, tc = %b", $time, rst, cep, cet, pen, c0.q, c0.tc);
    end

    initial begin
        $display("Checking counter...");
        $dumpfile("161_basics.vcd");
        $dumpvars(0, tb_161_basics);
        clk <= 0;
        rst <= 0;
        cep <= 1;
        cet <= 1;
        pen <= 1;
        d <= 4'he;

        #1 rst <= 1;
        $display ("Count");

        #16 
        rst <= 0;
        $display ("Reset");
        #10
        $display ("Release reset");
        rst <= 1;

        #20 
        $display ("Disable CEP");
        cep <= 0;
        #20 cep <= 1;
        $display ("Enable CEP");

        #30
        $display ("Parallel load");
        pen <= 0;
        #20
        $display ("Disable loading");
        pen <= 1;

        #10
        $display ("Disable CET");
        cet <= 0;
        #20 cet <= 1;

        $display ("Continue counting");

        #170 $finish;
    end
endmodule
