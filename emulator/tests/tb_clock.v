module tb_clock;

    reg auton;
    reg m;


    clock clk(.auton(auton), .m(m));

    initial begin
        $display("Clock....");
        $dumpfile("clock.vcd");
        $dumpvars(0, tb_clock);

        auton <= 1;
        m <= 0;

        $monitor("TB %t %b %b", $realtime, clk.clk, clk.iclk);

        #10 $display("%t %b %b", $realtime, clk.clk, clk.iclk);

        #1 auton <= 0;
        #1 auton <= 1;


        #31 m <= 1;
        #30 m <= 0;

        #30 m <= 1;
        #20 m <= 0;

        #50 $finish;

    end

endmodule
