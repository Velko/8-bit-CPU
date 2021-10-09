module tb_138;

    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    reg [4:0] expected;

    integer i, j, k;

    adder_283 adder(.a(a), .b(b), .cin(cin));

initial begin
    $display("Adder...");

    // loop all combinations with and without carry
    for (k = 0; k < 2; k = k + 1) begin
        cin <= k;
        for ( j = 0; j < 16; j = j + 1) begin
            b <= j;
            for ( i = 0; i < 16; i = i + 1) begin
                a <= i;
                expected <= i + j + k;
                #1
                `assert(adder.s, expected[3:0]);
                `assert(adder.cout, expected[4]);
            end
        end
    end

end

endmodule