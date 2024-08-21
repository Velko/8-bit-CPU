module tb_08p;

    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] y;

    integer i;

    and_08p logic_op(.a1(a[0]), .a2(a[1]), .a3(a[2]), .a4(a[3]), .b1(b[0]), .b2(b[1]), .b3(b[2]), .b4(b[3]));

    initial begin
        $display("74xx08 AND (pins variant)...");

        for (i = 0; i < 4; i = i + 1) begin
            a <= 4'bX;
            b <= 4'bX;

            a[i] <= 0;
            b[i] <= 0;

            #1
            `assert(y, bit0(i));

            a[i] <= 1;
            #1
            `assert(y, bit0(i));

            b[i] <= 1;
            #1
            `assert(y, bit1(i));

            a[i] <= 0;
            #1
            `assert(y, bit0(i));
        end

    end

    assign y = {logic_op.y4, logic_op.y3, logic_op.y2, logic_op.y1};

    function [3:0] bit1 (input [1:0] idx);
        bit1 = 4'bX | (1 << idx);
    endfunction

    function [3:0] bit0 (input [1:0] idx);
        bit0 = 4'bX & ~(1 << idx);
    endfunction

endmodule