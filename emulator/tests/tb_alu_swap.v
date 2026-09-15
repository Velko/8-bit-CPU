module tb_alu_swap;

    reg [7:0] input_l;
    reg outn;
    reg cin;

    integer i;

    alu_swap alu(.arg_l(input_l), .outn(outn));

    initial begin
        $display("ALU Swap...");
        input_l <= 0;

        outn <= 1;
        cin <= 0;

        // output disabled initially
        #1
        `assert(alu.bus, 8'bZ);

        // Swap nibbles
        input_l <= 8'h63;
        outn <= 0;
        #1
        `assert(alu.bus, 8'h36);

    end

endmodule
