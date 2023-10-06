module tb_377;

    reg cp;
    reg en;
    reg [7:0] data;

    dff_377 dff (
        .cp(cp),
        .en(en),
        .d(data)
    );


    initial begin
        $display("74xx377 D flip-flop...");

        cp <= 0;
        en <= 1;
        #1;

        `assert(dff.q, 8'bX);

        data <= 8'hA5;
        `tick(cp, 2);

        `assert(dff.q, 8'bX);

        en <= 0;
        `tick(cp, 2);
        `assert(dff.q, 8'hA5);
    end

endmodule