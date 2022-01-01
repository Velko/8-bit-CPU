module tb_193_chaining;

    reg cpd;
    reg cpu;
    reg rst;
    reg pl;
    reg [11:0] expected;

    udcounter_193 c0 (.d(4'h0), .mr(rst), .pl(pl), .cpu(cpu), .cpd(cpd));
    udcounter_193 c1 (.d(4'h0), .mr(rst), .pl(pl), .cpu(c0.tcu), .cpd(c0.tcd));
    udcounter_193 c2 (.d(4'h0), .mr(rst), .pl(pl), .cpu(c1.tcu), .cpd(c1.tcd));

    initial begin
        $display("74xx193 counter (chaining)...");

        cpu <= 1;
        cpd <= 1;
        pl <= 1;
        expected <= 0;

        // pull reset up initially, release it soon
        rst <= 1;
        #1
        rst <= 0;

        repeat (4096) begin
            #5
            `assert({c2.q, c1.q, c0.q}, expected);
            //$display("%h", expected);
            cpu <= 0;
            #5
            cpu <= 1;
            expected <= expected + 1;
        end

        repeat (4097) begin
            #5
            `assert({c2.q, c1.q, c0.q}, expected);
            //$display("%h", expected);
            cpd <= 0;
            #5
            cpd <= 1;
            expected <= expected - 1;
        end
    end
endmodule
