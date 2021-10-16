module tb_02b;

    reg [3:0] a;
    reg [3:0] b;

    integer i;

    nor_02b logic_op(.a(a), .b(b));

    initial begin
        $display("74xx02 NOR (bus variant)...");

        for (i = 0; i < 4; i = i + 1) begin
            a <= 4'bX;
            b <= 4'bX;

            a[i] <= 0;
            b[i] <= 0;

            #1
            `assert(logic_op.y, (4'bX | (1 << i)));

            a[i] <= 1;
            #1
            `assert(logic_op.y, (4'bX & ~(1 << i)));

            b[i] <= 1;
            #1
            `assert(logic_op.y, (4'bX & ~(1 << i)));

            a[i] <= 0;
            #1
            `assert(logic_op.y, (4'bX & ~(1 << i)));

        end

    end

endmodule