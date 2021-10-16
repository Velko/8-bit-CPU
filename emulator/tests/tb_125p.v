module tb_125p;

    reg a1;
    reg oen1;

    reg a2;
    reg oen2;

    reg a3;
    reg oen3;

    reg a4;
    reg oen4;

    buffer_125p buff(.a1(a1), .oen1(oen1), .a2(a2), .oen2(oen2), .a3(a3), .oen3(oen3), .a4(a4), .oen4(oen4));

    initial begin
        $display("74xx125 buffer...");

        oen1 <= 1;
        oen2 <= 1;
        oen3 <= 1;
        oen4 <= 1;

        #1
        `assert(buff.y1, 1'bz);
        oen1 <= 0;
        a1 <= 0;
        #1
        `assert(buff.y1, 1'b0);

        a1 <= 1;
        #1
        `assert(buff.y1, 1'b1);
        oen1 <= 1;


        #1
        `assert(buff.y2, 1'bz);
        oen2 <= 0;
        a2 <= 0;
        #1
        `assert(buff.y2, 1'b0);

        a2 <= 1;
        #1
        `assert(buff.y2, 1'b1);
        oen2 <= 1;


        #1
        `assert(buff.y3, 1'bz);
        oen3 <= 0;
        a3 <= 0;
        #1
        `assert(buff.y3, 1'b0);

        a3 <= 1;
        #1
        `assert(buff.y3, 1'b1);
        oen3 <= 1;


        #1
        `assert(buff.y4, 1'bz);
        oen4 <= 0;
        a4 <= 0;
        #1
        `assert(buff.y4, 1'b0);

        a4 <= 1;
        #1
        `assert(buff.y4, 1'b1);
        oen4 <= 1;


    end

endmodule
