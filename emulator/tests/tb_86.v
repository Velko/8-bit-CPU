module tb_86;

    reg [3:0] a;
    reg [3:0] b;

    integer i;

    xor_86 op_xor(.a(a), .b(b));

    initial begin
        $display("74xx86 XOR...");

        for (i = 0; i < 4; i = i + 1) begin
            a <= 4'bX;
            b <= 4'bX;

            a[i] <= 0;
            b[i] <= 0;

            #1
            `assert(op_xor.y[i], 1'b0);

            a[i] <= 1;
            #1
            `assert(op_xor.y[i], 1'b1);

            b[i] <= 1;
            #1
            `assert(op_xor.y[i], 1'b0);

            a[i] <= 0;
            #1
            `assert(op_xor.y[i], 1'b1);
        end

    end

endmodule