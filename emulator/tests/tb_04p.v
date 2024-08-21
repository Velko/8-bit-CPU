module tb_04p;

    reg [5:0] a;
    wire [5:0] y;

    integer i;

    not_04p logic_op(.a1(a[0]), .a2(a[1]), .a3(a[2]), .a4(a[3]), .a5(a[4]), .a6(a[5]));

    initial begin
        $display("74xx04 NOT (pins variant)...");

        for (i = 0; i < 6; i = i + 1) begin
            a <= 6'bX;

            a[i] <= 0;

            #1
            `assert(y, bit1(i));

            a[i] <= 1;
            #1
            `assert(y, bit0(i));
        end

    end

    assign y = {logic_op.y6, logic_op.y5, logic_op.y4, logic_op.y3, logic_op.y2, logic_op.y1};

    function [5:0] bit1 (input [3:0] idx);
        bit1 = 6'bX | (1 << idx);
    endfunction

    function [5:0] bit0 (input [3:0] idx);
        bit0 = 6'bX & ~(1 << idx);
    endfunction

endmodule