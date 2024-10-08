module tb_address_counter;

    reg outn;
    reg loadn;
    reg cupn;
    reg cdownn;

    reg clk;
    reg iclk;
    reg resetn;

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
        .resetn(resetn),
        .abus(abus));

    initial begin
        $display("Address Counter...");

        outn <= 1;
        loadn <= 1;
        cupn <= 1;
        cdownn <= 1;
        clk <= 0;
        iclk <= 0;
        resetn <= 1;
        wbus <= 0;

        // initial bus - disconnected
        #1
        `assert(abus, 16'bZ);

        // enable output from AC, value - undefined
        outn <= 0;
        #1
        `assert(abus, 16'bX);
        outn <= 1;

        // reset (should load what's on the address bus immediately)
        addr <= 16'hE000;
        wbus <= 1;
        resetn <= 0;
        #1
        resetn <= 1; // release reset and enable output
        wbus <= 0;
        outn <= 0;
        #1
        `assert(abus, 16'bX);

        `tick(iclk); // reset value propagation requires ICLK tick
        `assert(abus, 16'hE000);



        // count up one
        cupn <= 0;
        #1
        `tick(clk);
        `assert(abus, 16'hE000); // should still be E000

        `tick(iclk);          // load +1 into secondary stage
        `assert(abus, 16'hE001);

        cupn <= 1;
        #1

        // count down one
        cdownn <= 0;
        #1
        `tick(clk);
        `assert(abus, 16'hE001); // should still be +1

        `tick(iclk);          // load +0 into secondary stage
        `assert(abus, 16'hE000);

        cdownn <= 1;
        outn <= 1;
        #1


        // try to count up one, while OUT is not enabled
        cupn <= 0;
        #1
        `tick(clk);
        `tick(iclk);
        outn <= 0;
        #1
        `assert(abus, 16'hE000); // should remain unchanged
        outn <= 1;
        cupn <= 1;

        // try to count down one, while OUT is not enabled
        cdownn <= 0;
        #1
        `tick(clk);
        `tick(iclk);
        outn <= 0;
        #1
        `assert(abus, 16'hE000); // should remain unchanged
        outn <= 1;
        cdownn <= 1;

        // parallel load
        addr <= 16'hbeef;
        wbus <= 1;
        loadn <= 0;
        #1
        `tick(clk);

        wbus <= 0;
        outn <= 0;
        #1
        `assert(abus, 16'hE000); // should remain original

        `tick(iclk);
        `assert(abus, 16'hbeef); // load 0xbeef into secondary stage
        loadn <= 1;

        // reset to 0
        outn <= 1;
        addr <= 16'h0;
        wbus <= 1;
        #1
        resetn <= 0;
        #1

        // loop, check if increments correctly
        resetn <= 1;
        wbus <= 0;
        outn <= 0;
        `tick(iclk);
        cupn <= 0;
        #1

        for (i = 0; i < 'h10000 ; i = i + 1) begin
            #1
            `assert(abus, i);
            `tick(clk);
            `tick(iclk);
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
            `tick(clk);
            `tick(iclk);
        end
        cdownn <= 1;

        // should be wrapped around to 0xFFFF
        `assert(abus, 16'hffff);

    end

    assign abus = wbus ? addr : 16'bZ;

endmodule