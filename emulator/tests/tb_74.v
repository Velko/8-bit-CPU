module tb_74;
    reg rd1n;
    reg d1;
    reg cp1;
    reg sd1n;
    reg rd2n;
    reg d2;
    reg cp2;
    reg sd2n;


    dff_74 dff(.rd1n(rd1n), .d1(d1), .cp1(cp1), .sd1n(sd1n),
               .rd2n(rd2n), .d2(d2), .cp2(cp2), .sd2n(sd2n));

    initial begin
        $display("74xx74 D flip-flop...");

        rd1n <= 1;
        cp1 <= 0;
        sd1n <= 1;

        rd2n <= 1;
        cp2 <= 0;
        sd2n <= 1;

        #1
        // initial unknown state
        `assert(dff.q1, 1'bx);
        `assert(dff.q1n, 1'bx);

        // set
        sd1n <= 0;
        #1
        `assert(dff.q1, 1'b1);
        `assert(dff.q1n, 1'b0);

        // both set and reset
        rd1n <= 0;
        #1
        `assert(dff.q1, 1'b1);
        `assert(dff.q1n, 1'b1);

        // release set
        sd1n <= 1;
        #1
        `assert(dff.q1, 1'b0);
        `assert(dff.q1n, 1'b1);

        // both set and reset again
        sd1n <= 0;
        #1
        `assert(dff.q1, 1'b1);
        `assert(dff.q1n, 1'b1);

        // release reset
        rd1n <= 1;
        #1
        `assert(dff.q1, 1'b1);
        `assert(dff.q1n, 1'b0);

        // release set
        sd1n <= 1;
        #1
        `assert(dff.q1, 1'b1);
        `assert(dff.q1n, 1'b0);

        // load data
        d1 <= 0;
        #1
        `assert(dff.q1, 1'b1);
        `assert(dff.q1n, 1'b0);

        // clock in
        `tick(cp1);
        `assert(dff.q1, 1'b0);
        `assert(dff.q1n, 1'b1);

        // load opposite bit
        d1 <= 1;
        #1
        `assert(dff.q1, 1'b0);
        `assert(dff.q1n, 1'b1);

        // clock in
        `tick(cp1);
        `assert(dff.q1, 1'b1);
        `assert(dff.q1n, 1'b0);

        // reset
        rd1n <= 0;
        #1
        `assert(dff.q1, 1'b0);
        `assert(dff.q1n, 1'b1);

        // -------------------------------------------------------------
        // now the same with unit 2

        // initial unknown state
        `assert(dff.q2, 1'bx);
        `assert(dff.q2n, 1'bx);

        // set
        sd2n <= 0;
        #1
        `assert(dff.q2, 1'b1);
        `assert(dff.q2n, 1'b0);

        // both set and reset
        rd2n <= 0;
        #1
        `assert(dff.q2, 1'b1);
        `assert(dff.q2n, 1'b1);

        // release set
        sd2n <= 1;
        #1
        `assert(dff.q2, 1'b0);
        `assert(dff.q2n, 1'b1);

        // both set and reset again
        sd2n <= 0;
        #1
        `assert(dff.q2, 1'b1);
        `assert(dff.q2n, 1'b1);

        // release reset
        rd2n <= 1;
        #1
        `assert(dff.q2, 1'b1);
        `assert(dff.q2n, 1'b0);

        // release set
        sd2n <= 1;
        #1
        `assert(dff.q2, 1'b1);
        `assert(dff.q2n, 1'b0);

        // load data
        d2 <= 0;
        #1
        `assert(dff.q2, 1'b1);
        `assert(dff.q2n, 1'b0);

        // clock in
        `tick(cp2);
        `assert(dff.q2, 1'b0);
        `assert(dff.q2n, 1'b1);

        // load opposite bit
        d2 <= 1;
        #1
        `assert(dff.q2, 1'b0);
        `assert(dff.q2n, 1'b1);

        // clock in
        `tick(cp2);
        `assert(dff.q2, 1'b1);
        `assert(dff.q2n, 1'b0);

        // reset
        rd2n <= 0;
        #1
        `assert(dff.q2, 1'b0);
        `assert(dff.q2n, 1'b1);

    end


endmodule