module tb_memory;

    reg wen;
    reg outn;
    reg clk;
    reg [15:0] addr;
    reg saddr;

    reg [7:0] data;
    reg wdata;

    wire [7:0] mbus;
    wire [15:0] abus;

    memory m(
        .outn(outn),
        .writen(wen),
        .clk(clk),
        .abus(abus),
        .mbus(mbus));

    initial begin
        $display("Memory...");
        wdata <= 0;
        saddr <= 0;
        outn <= 1;
        wen <= 1;
        clk <= 0;
        #1

        `assert(abus, 16'hE000);    // Address Bus pulled to reset value initially

        addr <= 16'h2003;
        saddr <= 1;
        #1
        `assert(mbus, 8'bz);        // Main Bus keeps floating when address is set, but no output

        // RAM at addr 0x2003 does not have defined value yet
        outn <= 0;
        #1
        `assert(mbus, 8'bx);

        // Go to addr 0xE007 (ROM)
        addr <= 16'hE007;
        #1
        `assert(mbus, 8'hc0);

        // write 0xA5 to RAM at 0x0004
        addr <= 16'h0004;
        outn <= 1;
        wen <= 0;
        data <= 8'ha5;
        wdata <= 1;
        #1
        `tick(clk, 2);

        // read it back
        wdata <= 0;
        wen <= 1;
        outn <= 0;
        #1
        `assert(mbus, 8'ha5);

        // go to addr 0x2001
        addr <= 16'h2001;
        #1
        `assert(mbus, 8'bx);

        // go back to addr 0x0004
        addr <= 16'h0004;
        #1
        `assert(mbus, 8'ha5);

    end

    assign mbus = wdata ? data : 8'bZ;
    assign abus = saddr ? addr : 16'bZ;


endmodule