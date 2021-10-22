module tb_alu_andor;

    reg [7:0] input_l;
    reg [7:0] input_r;
    reg alt;
    reg outn;

    integer i;

    alu_andor alu(.arg_l(input_l), .arg_r(input_r), .fn_or(alt), .outn(outn));

    initial begin
        $display("ALU And/Or...");
        input_l <= 0;
        input_r <= 0;

        outn <= 1;
        alt <= 0;

        // output disabled initially
        #1
        `assert(alu.bus, 8'bZ);

        // AND from LHS
        outn <= 0;
        input_r <= 8'hff;
        for (i = 0; i < 8 ; i = i + 1) begin
            input_l <= (8'b1 << i);
            #1
            `assert(alu.bus, (8'b1 << i));
        end

        // AND from RHS
        input_l <= 8'hff;
        for (i = 0; i < 8 ; i = i + 1) begin
            input_r <= (8'b1 << i);
            #1
            `assert(alu.bus, (8'b1 << i));
        end

        // OR from LHS
        alt <= 1;
        input_r <= 8'h00;
        for (i = 0; i < 8 ; i = i + 1) begin
            input_l <= (8'b1 << i);
            #1
            `assert(alu.bus, (8'b1 << i));
        end

        // AND from RHS
        input_l <= 8'h00;
        for (i = 0; i < 8 ; i = i + 1) begin
            input_r <= (8'b1 << i);
            #1
            `assert(alu.bus, (8'b1 << i));
        end

    end

endmodule