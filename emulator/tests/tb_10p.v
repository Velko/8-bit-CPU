module tb_10p;

    reg [2:0] a;
    reg [2:0] b;
    reg [2:0] c;
    wire [2:0] y;

    integer i, v;

    nand_10p logic_op(
        .a1(a[0]),
        .a2(a[1]),
        .a3(a[2]),
        .b1(b[0]),
        .b2(b[1]),
        .b3(b[2]),
        .c1(c[0]),
        .c2(c[1]),
        .c3(c[2]));

    initial begin
        $display("74xx10 NAND (pins variant)...");

        for (i = 0; i < 4; i = i + 1) begin
            a <= 4'bX;
            b <= 4'bX;
            c <= 4'bX;

            for (v = 0; v < 7; v = v + 1) begin
                a[i] <= (v & 3'b001) != 0;
                b[i] <= (v & 3'b010) != 0;;
                c[i] <= (v & 3'b100) != 0;;

                #1
                `assert(y, bit1(i));
            end

            a[i] <= 1;
            b[i] <= 1;
            c[i] <= 1;
            #1
            `assert(y, bit0(i));
        end

    end

    assign y = {logic_op.y3, logic_op.y2, logic_op.y1};

    function [2:0] bit1 (input [1:0] idx);
        bit1 = 3'bX | (1 << idx);
    endfunction

    function [2:0] bit0 (input [1:0] idx);
        bit0 = 3'bX & ~(1 << idx);
    endfunction

endmodule