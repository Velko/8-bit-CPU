module tb_rom_async;

    reg cen;
    reg oen;
    reg [16:0] addr;


    //SST39F010A: 1Mbit x 8
    rom_async #(.ROMFILE("testrom.hex"), .ADDR_BITS(17)) rom (
        .cen(cen),
        .oen(oen),
        .addr(addr)
    );

    initial begin
        $display("SST39F010A ROM...");

        cen <= 1;
        oen <= 1;
        #1

        `assert(rom.data, 8'bz);

        cen <= 0;
        #1
        `assert(rom.data, 8'bz);

        oen <= 0;
        addr <= 0;
        #1
        `assert(rom.data, 8'h0a);

        addr <= 44567;
        #1
        `assert(rom.data, 8'hab);

        addr <= 131071;
        #1
        `assert(rom.data, 8'h03);

    end


endmodule