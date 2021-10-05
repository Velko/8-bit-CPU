module tb_173;

    reg mr;
    reg cp;
    reg e1n;
    reg e2n;
    reg oe1n;
    reg oe2n;
    reg [3:0] data;

    dff_173 dff(.mr(mr), .cp(cp), .e1n(e1n), .e2n(e2n), .oe1n(oe1n), .oe2n(oe2n), .d(data));

    initial begin
        cp <= 0;
        mr <= 0;

        e1n <= 1;
        e2n <= 1;
        oe1n <= 1;
        oe2n <= 1;

        #1
        `assert(dff.q, 4'bZ);

        #1 cp <=1;
        #1 cp <=0;
        `assert(dff.q, 4'bZ);

        oe1n <= 0;
        #1
        `assert(dff.q, 4'bZ);

        oe2n <= 0;
        #1
        `assert(dff.q, 4'bX);

        data <= 5;

        e1n <= 0;
        #1 cp <=1;
        #1 cp <=0;
        `assert(dff.q, 4'bX);

        e2n <= 0;
        #1 cp <=1;
        #1 cp <=0;
        `assert(dff.q, 4'h5);

        mr <= 1;
        #1
        `assert(dff.q, 4'h0);

        oe1n <= 1;
        #1
        `assert(dff.q, 4'bZ);
    end

endmodule