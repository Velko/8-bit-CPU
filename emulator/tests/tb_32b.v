module tb_32b;

    reg [3:0] a;
    reg [3:0] b;

    integer i;

    or_32b logic_op(.a(a), .b(b));

    initial begin
        $display("74xx32 OR (bus variant)...");

        for (i = 0; i < 4; i = i + 1) begin
            a <= 4'bX;
            b <= 4'bX;

            a[i] <= 0;
            b[i] <= 0;

            #1
            `assert(logic_op.y, bit0(i));

            a[i] <= 1;
            #1
            `assert(logic_op.y, bit1(i));

            b[i] <= 1;
            #1
            `assert(logic_op.y, bit1(i));

            a[i] <= 0;
            #1
            `assert(logic_op.y, bit1(i));

        end

    end

    function [3:0] bit1 (input [1:0] idx);
        bit1 = 4'bX | (1 << idx);
    endfunction

    function [3:0] bit0 (input [1:0] idx);
        bit0 = 4'bX & ~(1 << idx);
    endfunction

endmodule