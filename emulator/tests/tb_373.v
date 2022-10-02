module tb_373;

    reg oen;
    reg le;
    reg [7:0] data;

    tlatch_373 latch (
        .oen(oen),
        .le(le),
        .d(data)
    );


    initial begin
        $display("74xx373 transparent latch...");
        oen <= 1;
        le <= 0;

        #1
        `assert(latch.q, 8'bZ);

        oen <= 0;
        #1
        `assert(latch.q, 8'bX);

        data <= 8'hAA;
        #1
        `assert(latch.q, 8'bX);

        le <= 1;
        #1
        `assert(latch.q, 8'hAA);

        data <= 8'h55;
        #1
        `assert(latch.q, 8'h55);

        le <= 0;
        data <= 0;
        #1
        `assert(latch.q, 8'h55);
    end

endmodule