module tb_alu_shiftswap;

    reg [7:0] input_l;
    reg alt;
    reg outn;
    reg cin;

    integer i;

    alu_shiftswap alu(.arg_l(input_l), .fn_swap(alt), .outn(outn), .cin(cin));

    initial begin
        $display("ALU Shift/Swap...");
        input_l <= 0;

        outn <= 1;
        alt <= 0;
        cin <= 0;

        // output disabled initially
        #1
        `assert(alu.bus, 8'bZ);
        `assert(alu.cout, 1'bZ);


        // SHR with carry in 0
        outn <= 0;
        for (i = 1; i < 8 ; i = i + 1) begin
            input_l <= (8'b1 << i);
            #1
            `assert(alu.bus, (8'b1 << (i - 1)));
            `assert(alu.cout, 8'b0);
        end

        
        // SHR with carry in 1
        input_l <= 8'h01;
        cin <= 1'b1;
        #1
        `assert(alu.bus, 8'h80);
        `assert(alu.cout, 8'b1);


        // Swap nibbles
        input_l <= 8'h63;
        alt <= 1;
        #1
        `assert(alu.bus, 8'h36);

    end

endmodule
