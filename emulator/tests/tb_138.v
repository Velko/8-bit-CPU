module tb_138;

    reg [2:0] addr;
    reg e1n;
    reg e2n;
    reg e3;

    demux_138 dmx(.a(addr), .e1n(e1n), .e2n(e2n), .e3(e3));

    initial begin
        $display("74xx138 demultiplexer");
        //$monitor("%b%b%b %x %b", e1n, e2n, e3, addr, dmx.y);

        e1n <= 0;
        e2n <= 0;
        e3  <= 0;

        addr <= 0;
        #1 `assert (dmx.y, 8'b11111111);

        e3 <= 1;
        #1 `assert (dmx.y, 8'b11111110);

        addr <= 1;
        #1 `assert (dmx.y, 8'b11111101);

        addr <= 2;
        #1 `assert (dmx.y, 8'b11111011);

        addr <= 3;
        #1 `assert (dmx.y, 8'b11110111);

        e2n <= 1;
        #1 `assert (dmx.y, 8'b11111111);

        addr <= 4; e2n <=0;
        #1 `assert (dmx.y, 8'b11101111);

        addr <= 5;
        #1 `assert (dmx.y, 8'b11011111);

        addr <= 6;
        #1 `assert (dmx.y, 8'b10111111);

        addr <= 7;
        #1 `assert (dmx.y, 8'b01111111);

        e1n <= 1;
        #1 `assert (dmx.y, 8'b11111111);
    end

endmodule
