module tb_gp_register;

    reg outn;
    reg loadn;
    reg loutn;
    reg routn;

    reg clk;
    reg iclk;

    wire [7:0] bus;

    reg [7:0] data;
    reg wbus;


    gp_register r(
        .outn(outn),
        .loadn(loadn),
        .loutn(loutn),
        .routn(routn),
        .clk(clk),
        .iclk(iclk),
        .bus(bus));

    initial begin
        $display("Register module...");
        wbus <= 0;
        data <= 8'h3a;

        outn <= 1;
        loadn <= 1;
        loutn <= 1;
        routn <= 1;

        clk <= 0;
        iclk <= 0;

        // initial bus - disconnected
        #1
        `assert(bus, 8'bZ);

        // output register - uninitialized
        outn <= 0;
        #1
        `assert(bus, 8'bX);

        // disable output
        outn <= 1;
        #1
        `assert(bus, 8'bZ);

        // drive bus externally
        wbus <= 1;
        #1
        `assert(bus, 8'h3a);

        // load into register
        loadn <= 0;
        `tick(clk, 2);

        // release bus
        wbus <= 0;
        loadn <= 1;
        #1
        `assert(bus, 8'bZ);

        // output register
        outn <= 0;
        #1
        `assert(bus, 8'h3a);

        // check ALU LHS output (disconnected initially)
        `assert(r.alu_l, 8'bZ);

        // enable it, holds undefined value
        loutn <= 0;
        #1
        `assert(r.alu_l, 8'hX);

        // after iclk, should load from primary
        `tick(iclk, 2);
        `assert(r.alu_l, 8'h3a);

        // check ALU RHS output (disconnected initially)
        `assert(r.alu_r, 8'bZ);

        // enable it - loaded value
        routn <= 0;
        #1
        `assert(r.alu_r, 8'h3a);

    end

    assign bus = wbus ? data : 8'bZ;

endmodule
