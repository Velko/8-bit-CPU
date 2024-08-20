module tb_address_counter;

    reg outn;
    reg loadn;
    reg cupn;
    reg cdownn;

    reg clk;
    reg iclk;
    reg reset;

    wire [15:0] abus;
    reg [15:0] addr;
    reg wbus;

    integer i;

    address_counter ac(
        .outn(outn),
        .loadn(loadn),
        .cupn(cupn),
        .cdownn(cdownn),
        .clk(clk),
        .iclk(iclk),
        .reset(reset),
        .abus(abus));

initial begin
        $display("Address Counter...");

        outn <= 1;
        loadn <= 1;
        cupn <= 1;
        cdownn <= 1;
        clk <= 0;
        iclk <= 0;
        reset <= 0;
        wbus <= 0;

        // initial bus - disconnected
        #1
        `assert(abus, 16'bZ);

        // enable output from AC, value - undefined
        outn <= 0;
        #1
        `assert(abus, 16'bX);

        // reset
        reset <= 1;
        #1
        `assert(abus, 16'bX);

        `tick(iclk, 2); // reset value propagation requires ICLK tick
        `assert(abus, 16'b0);


        reset <= 0;

        // count up one
        cupn <= 0;
        #1
        `tick(clk, 2);
        `assert(abus, 16'b0); // should still be 0

        `tick(iclk, 2);
        `assert(abus, 16'b1); // load 1 into secondary stage

        cupn <= 1;
        #1

        // count down one
        cdownn <= 0;
        #1
        `tick(clk, 2);
        `assert(abus, 16'b1); // should still be 1

        `tick(iclk, 2);
        `assert(abus, 16'b0); // load 0 into secondary stage

        cdownn <= 1;
        outn <= 1;
        #1


        // try to count up one, while OUT is not enabled
        cupn <= 0;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);
        outn <= 0;
        #1
        `assert(abus, 16'b0); // should still be 0
        outn <= 1;
        cupn <= 1;

        // try to count down one, while OUT is not enabled
        cdownn <= 0;
        #1
        `tick(clk, 2);
        `tick(iclk, 2);
        outn <= 0;
        #1
        `assert(abus, 16'b0); // should still be 0
        outn <= 1;
        cdownn <= 1;

        // parallel load
        addr <= 16'hbeef;
        wbus <= 1;
        loadn <= 0;
        #1
        `tick(clk, 2);

        wbus <= 0;
        outn <= 0;
        #1
        `assert(abus, 16'b0); // should still be 0

        `tick(iclk, 2);
        `assert(abus, 16'hbeef); // load 0xbeef into secondary stage
        loadn <= 1;

        // reset
        reset <= 1;
        #1

        // loop, check if increments correctly
        reset <= 0;
        `tick(iclk, 2);
        cupn <= 0;
        #1

        for (i = 0; i < 'h10000 ; i = i + 1) begin
            #1
            `assert(abus, i);
            `tick(clk, 2);
            `tick(iclk, 2);
        end
        cupn <= 1;

        // should be wrapped around to 0
        `assert(abus, 16'b0);

        // loop, check if decrements correctly
        cdownn <= 0;
        #1

        for (i = 'h10000; i >= 0  ; i = i - 1) begin
            #1
            `assert(abus, (i & 'hffff));
            `tick(clk, 2);
            `tick(iclk, 2);
        end
        cdownn <= 1;

        // should be wrapped around to 0xFFFF
        `assert(abus, 16'hffff);

end

    assign abus = wbus ? addr : 16'bZ;

endmodule