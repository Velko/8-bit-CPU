module tb_193_basics;

    reg [3:0] d;
    reg cpu;
    reg cpd;
    reg mr;
    reg pl;

    udcounter_193 udc(.d(d), .cpu(cpu), .cpd(cpd), .mr(mr), .pl(pl));

    initial begin
        $display("74xx193 counter (basics)...");
        cpu <= 1'b1;
        cpd <= 1'b1;
        pl <= 1'b1;
        mr <= 1'b0;
        d <= 4'b0101;
        #1

        // unknown initial state
        `assert(udc.q, 4'bxxxx);

        // reset
        mr <= 1'b1;
        #1
        `assert(udc.q, 4'b0000);

        // enable pl, keep resetting
        pl <= 1'b0;
        #1
        `assert(udc.q, 4'b0000);

        // release reset
        mr <= 1'b0;
        #1
        `assert(udc.q, 4'b0101);
        `assert(udc.tcu, 1'b1);
        `assert(udc.tcd, 1'b1);

        // release pl
        pl <= 1'b1;

        // pull cpu down (same value)
        cpu <= 0;
        #1
        `assert(udc.q, 4'b0101);
        `assert(udc.tcu, 1'b1);
        `assert(udc.tcd, 1'b1);


        // release cpu (increment)
        cpu <= 1;
        #1
        `assert(udc.q, 4'b0110);
        `assert(udc.tcu, 1'b1);
        `assert(udc.tcd, 1'b1);


        // pull cpd down (same value)
        cpd <= 0;
        #1
        `assert(udc.q, 4'b0110);
        `assert(udc.tcu, 1'b1);
        `assert(udc.tcd, 1'b1);


        // release cpu (decrement)
        cpd <= 1;
        #1
        `assert(udc.q, 4'b0101);
        `assert(udc.tcu, 1'b1);
        `assert(udc.tcd, 1'b1);


        // pull both cp down
        cpu <= 0;
        cpd <= 0;
        #1
        `assert(udc.q, 4'b0101);
        `assert(udc.tcu, 1'b1);
        `assert(udc.tcd, 1'b1);


        // release cpd (no effect)
        cpd <= 1;
        #1
        `assert(udc.q, 4'b0101);
        `assert(udc.tcu, 1'b1);
        `assert(udc.tcd, 1'b1);

        // release cpu (no effect)
        cpu <= 1;
        cpd <= 0;
        #1
        `assert(udc.q, 4'b0101);
        `assert(udc.tcu, 1'b1);
        `assert(udc.tcd, 1'b1);


        // reset
        mr <= 1;
        cpu <= 1;
        cpd <= 1;
        #1
        `assert(udc.tcu, 1'b1);
        `assert(udc.tcd, 1'b1);

        // tcd should follow cpd
        cpd <= 0;
        #1
        `assert(udc.tcu, 1'b1);
        `assert(udc.tcd, 1'b0);

        // count down
        mr <= 0;
        cpd <= 1;
        #1
        `assert(udc.q, 4'b1111);
        `assert(udc.tcu, 1'b1);
        `assert(udc.tcd, 1'b1);

        // tcu should follow cpu
        cpu <= 0;
        #1
        `assert(udc.tcu, 1'b0);
        `assert(udc.tcd, 1'b1);

        // count up
        cpu <= 1;
        #1
        `assert(udc.q, 4'b0000);
        `assert(udc.tcu, 1'b1);
        `assert(udc.tcd, 1'b1);

    end

endmodule