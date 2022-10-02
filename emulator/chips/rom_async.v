module rom_async #(parameter ROMFILE = "rom.hex", parameter ADDR_BITS=15) (
    input cen,
    input oen,

    input [(ADDR_BITS-1):0] addr,
    output [7:0] data
);

    reg [7:0] memory [0:(1<<ADDR_BITS)-1];

    // Output/Tri-state
    assign data = (!cen && !oen) ? memory[addr] : 8'bz;

    initial begin
        $readmemh(ROMFILE, memory);
    end

    /* Instantiation:
    rom_async #(.ROMFILE("rom.hex"), .ADDR_BITS(15)) new_instance (
        .cen(),
        .oen(),

        .addr(),
        .data()
    );
    */

endmodule