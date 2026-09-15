module tb_alu_xor;

    reg [7:0] input_l;
    reg [7:0] input_r;
    reg outn;

    integer i;

    alu_xor alu(.arg_l(input_l), .arg_r(input_r), .outn(outn));

    initial begin
        $display("ALU Xor...");
        input_l <= 0;
        input_r <= 0;

        outn <= 1;

        // output disabled initially
        #1
        `assert(alu.bus, 8'bZ);

        // XOR LHS with 0
        outn <= 0;
        input_r <= 8'h00;
        for (i = 0; i < 8 ; i = i + 1) begin
            input_l <= (8'b1 << i);
            #1
            `assert(alu.bus, (8'b1 << i));
        end

        // XOR LHS with 1
        input_r <= 8'hff;
        for (i = 0; i < 8 ; i = i + 1) begin
            input_l <= (8'b1 << i);
            #1
            `assert(alu.bus, ~(8'b1 << i));
        end

        // XOR RHS with 0
        input_l <= 8'h00;
        for (i = 0; i < 8 ; i = i + 1) begin
            input_r <= (8'b1 << i);
            #1
            `assert(alu.bus, (8'b1 << i));
        end

        // XOR RHS with 1
        input_l <= 8'hff;
        for (i = 0; i < 8 ; i = i + 1) begin
            input_r <= (8'b1 << i);
            #1
            `assert(alu.bus, ~(8'b1 << i));
        end
    end

endmodule
