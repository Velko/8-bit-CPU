module tb_program_counter;

    reg outn;
    reg loadn;
    reg count;

    reg clk;
    reg iclk;
    reg reset;
    wire resetn;

    wire [15:0] abus;
    reg [15:0] addr;
    reg wbus;

    integer i;

    program_counter pc (.outn(outn), .loadn(loadn), .count(count), .clk(clk), .iclk(iclk), .reset(reset), .resetn(resetn), .abus(abus));

initial begin
        $display("Program counter...");

        outn <= 1;
        loadn <= 1;
        count <= 0;
        clk <= 0;
        iclk <= 0;
        reset <= 0;
        wbus <= 0;

        // initial bus - disconnected
        #1
        `assert(abus, 16'bZ);

        // enable output from PC, value - undefined
        outn <= 0;
        #1
        `assert(abus, 16'bX);

        // reset
        reset <= 1;
        #1
        `assert(abus, 16'b0);
        reset <= 0;

        // count up one
        count <= 1;
        #1
        `tick(clk, 2);
        `assert(abus, 16'b0); // should still be 0

        `tick(iclk, 2);
        `assert(abus, 16'b1); // load 1 into secondary stage

        count <= 0;
        outn <= 1;
        #1

        // parallel load
        addr <= 16'hbeef;
        wbus <= 1;
        loadn <= 0;
        #1
        `tick(clk, 2);

        wbus <= 0;
        outn <= 0;
        #1
        `assert(abus, 16'b1); // should still be 1

        `tick(iclk, 2);
        `assert(abus, 16'hbeef); // load 0xbeef into secondary stage
        loadn <= 1;

        // reset
        reset <= 1;
        #1

        // loop, check if increments correctly
        reset <= 0;
        count <= 1;
        #1

        for (i = 0; i < 'h10000 ; i = i + 1) begin
            #1
            `assert(abus, i);
            `tick(clk, 2);
            `tick(iclk, 2);
        end

        // should be wrapped around to 0
        `assert(abus, 16'b0);

end

    assign resetn = !reset;
    assign abus = wbus ? addr : 16'bZ;

endmodule