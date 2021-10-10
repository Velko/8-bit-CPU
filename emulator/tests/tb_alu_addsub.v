module tb_alu_addsub;

    reg [7:0] input_l;
    reg [7:0] input_r;
    reg sub;
    reg outn;

    alu_addsub alu(.arg_l(input_l), .arg_r(input_r), .sub(sub), .outn(outn));


    initial begin
        input_l <= 0;
        input_r <= 1;

        outn <= 1;
        sub <= 0;

        // output disabled initially
        #1
        `assert(alu.bus, 8'bZ);

        // enable output, check 0 + 1
        outn <= 0;
        #1
        `assert(alu.bus, 8'h01);

        // go to 127 + 1
        input_l <= 127;
        #1
        `assert(alu.bus, 8'h80);
        //TODO: signed overflow

        // go to 255 + 1
        input_l <= 255;
        #1
        `assert(alu.bus, 8'h0);
        //TODO: carry

        // subtract 3 - 2
        sub <= 1;
        input_l <= 3;
        input_r <= 2;
        #1
        `assert(alu.bus, 8'h01);
        //TODO: no borrow

        // try 3 - 6
        input_r <= 6;
        #1
        `assert(alu.bus, 8'hfd);
        //TODO: borrow


        $display(alu.bus);



    end

endmodule