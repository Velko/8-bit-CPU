module tb_memory;

    reg wen;
    reg outn;
    reg clk;
    reg [15:0] addr;

    reg [7:0] data;
    reg wdata;

    wire [7:0] mbus;

    memory m(.outn(outn), .writen(wen), .clk(clk), .abus(addr), .mbus(mbus));

    initial begin
        $display("Memory...");
        wdata <= 0;
        outn <= 1;
        wen <= 1;
        clk <= 0;

        addr <= 8;
        #1

        // bus disconnected
        `assert(mbus, 8'bz);

        // output current at addr 8 (ROM)
        outn <= 0;
        #1
        `assert(mbus, 8'hc0);

        // output current at addr 0x2003 (ROM)
        addr <= 16'h2003;
        #1
        `assert(mbus, 8'bx);

        // write 0xA5
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

        // go back to addr 0x2003
        addr <= 16'h2003;
        #1
        `assert(mbus, 8'ha5);

    end

    assign mbus = wdata ? data : 8'bZ;


endmodule