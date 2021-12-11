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

        wdata <= 0;
        outn <= 1;
        wen <= 1;
        clk <= 0;

        addr <= 3;
        #1

        // bus disconnected
        `assert(mbus, 8'bz);

        // output current at addr 0
        outn <= 0;
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

        // go to addr 1
        addr <= 1;
        #1
        `assert(mbus, 8'bx);

        // go back to addr 3
        addr <= 3;
        #1
        `assert(mbus, 8'ha5);

    end

    assign mbus = wdata ? data : 8'bZ;


endmodule