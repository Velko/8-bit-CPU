module tb_85b;

    integer a;
    integer b;

    reg ilt;
    reg igt;
    reg ieq;

    cmp_85b logic_op(.a(a[3:0]), .b(b[3:0]), .ilt(ilt), .igt(igt), .ieq(ieq));

    initial begin
        $display("74xx85 CMP (bus variant)...");

        for (a = 0; a < 16; a = a + 1) begin
            for (b = 0; b < 16; b = b + 1) begin
                ilt <= 1'bX;
                igt <= 1'bX;
                ieq <= 1'bX;

                #1;
                `assert(logic_op.qlt, (a < b));
                `assert(logic_op.qgt, (a > b));

                if (a == b) begin
                    ieq <= 1'b0;
                    #1
                    `assert(logic_op.qeq, ieq);

                    ieq <= 1'b1;
                    #1
                    `assert(logic_op.qeq, ieq);
                end
            end
        end
    end
endmodule