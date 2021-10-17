module tb_alu_addsub;

    reg [7:0] input_l;
    reg [7:0] input_r;
    reg sub;
    reg outn;
    reg cin;

    alu_addsub alu(.arg_l(input_l), .arg_r(input_r), .cin(cin), .sub(sub), .outn(outn));


    initial begin
        $display("ALU Add/Sub...");
        input_l <= 0;
        input_r <= 1;

        cin <= 0;
        outn <= 1;
        sub <= 0;

        // output disabled initially
        #1
        `assert(alu.bus, 8'bZ);
        `assert(alu.vout, 1'bz);
        `assert(alu.cout, 1'bz);

        // enable output, check 0 + 1
        outn <= 0;
        #1
        `assert(alu.bus, 8'h01);
        `assert(alu.cout, 8'b0);
        `assert(alu.vout, 8'b0);

        // enable carry-in (add one more)
        cin <= 1;
        #1
        `assert(alu.bus, 8'h02);
        cin <= 0;

        // go to 127 + 1
        input_l <= 127;
        #1
        `assert(alu.bus, 8'h80);
        `assert(alu.vout, 8'b1);

        // go to 255 + 1
        input_l <= 255;
        #1
        `assert(alu.bus, 8'h0);
        `assert(alu.cout, 8'b1);
        `assert(alu.vout, 8'b0);

        // subtract 3 - 2
        sub <= 1;
        input_l <= 3;
        input_r <= 2;
        #1
        `assert(alu.bus, 8'h01);
        `assert(alu.cout, 8'b0);

        // enable borrow-in (subtract one more)
        cin <= 1;
        #1
        `assert(alu.bus, 8'h00);
        cin <= 0;

        // try 3 - 6
        input_r <= 6;
        #1
        `assert(alu.bus, 8'hfd);
        `assert(alu.cout, 8'b1);


//        $display(alu.bus);



    end

endmodule
