module tb_374;

    reg cp;
    reg oen;
    reg [7:0] data;

    dff_374 dff (
        .cp(cp),
        .oen(oen),
        .d(data)
    );

    initial begin
        $display("74xx374 D flip-flop...");
        cp <= 0;
        oen <= 1;
        #1;

        `assert(dff.q, 8'bZ);

        `tick(cp, 2);
        `assert(dff.q, 8'bZ);

        oen <= 0;
        #1;
        `assert(dff.q, 8'bX);

        data <= 8'h5A;

        `tick(cp, 2);
        `assert(dff.q, 8'h5A);

        oen <= 1;
        #1
        `assert(dff.q, 8'bZ);
    end

endmodule