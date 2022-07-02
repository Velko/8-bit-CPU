module tb_address_calc;

    wire [15:0] abus;
    reg waddr;
    reg [15:0] addr;

    reg [7:0] mbus;

    reg clk;
    reg reset;
    reg outn;
    reg loadn;

    address_calc acalc(
        .abus(abus),
        .mbus(mbus),

        .clk(clk),
        .reset(reset),

        .outn(outn),
        .loadn(loadn)
    );

initial begin
    $display("Address calculator...");

    waddr <= 0;
    clk <= 0;
    reset <= 1;
    outn <= 1;
    loadn <= 1;
    #1 reset <= 0;

    addr <= 16'd64737;
    mbus <= 8'd168;
    waddr <= 1;
    loadn <= 0;

    #1
    `tick(clk, 2);

    waddr <= 0;
    outn <= 0;
    loadn <= 1;
    #1

    `assert(abus, 16'd64649);
end

    assign abus = waddr ? addr : 16'bz;

endmodule