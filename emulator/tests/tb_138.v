module tb_138;

    reg [2:0] addr;
    reg e1n;
    reg e2n;
    reg e3;

    demux_138 dmx(.a(addr), .e1n(e1n), .e2n(e2n), .e3(e3)); 

    initial begin
        $monitor("%b%b%b %x %b", e1n, e2n, e3, addr, dmx.y);
        
        e1n <= 0;
        e2n <= 0;
        e3  <= 0;


        addr <= 0;
        #1 e3 <= 1;
        #1 addr <= 1;
        #1 addr <= 2;
        #1 addr <= 3;
        #1 e2n <= 1;
        #1 addr <= 4; e2n <=0;
        #1 addr <= 5;
        #1 addr <= 6;
        #1 addr <= 7;
        #1 e1n <= 1;
    end

endmodule
