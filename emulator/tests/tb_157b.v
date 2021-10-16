module tb_157;

    reg [3:0] a;
    reg [3:0] b;

    reg en;
    reg sel;

    mux_157b mux(.a(a), .b(b), .en(en), .sel(sel));

    initial begin
        $display("74xx157 MUX...");

        a <= 4'bx;
        b <= 4'bx;
        sel <= 1'bx;        

        en <= 1;
        #1
        `assert(mux.y, 4'b0000);

        en <= 0;
        sel <= 0;

        a <= 4'b0001;
        #1
        `assert(mux.y, 4'b0001);

        a <= 4'b0010;
        #1
        `assert(mux.y, 4'b0010);

        a <= 4'b0100;
        #1
        `assert(mux.y, 4'b0100);

        a <= 4'b1000;
        #1
        `assert(mux.y, 4'b1000);

        a <= 4'bx;
        sel <= 1;        
        
        b <= 4'b0001;
        #1
        `assert(mux.y, 4'b0001);

        b <= 4'b0010;
        #1
        `assert(mux.y, 4'b0010);

        b <= 4'b0100;
        #1
        `assert(mux.y, 4'b0100);

        b <= 4'b1000;
        #1
        `assert(mux.y, 4'b1000);
        
        

    end

endmodule
