module ram_62256 (
    input [14:0] addr,
    inout [7:0] data,

    input csn,
    input oen,
    input wen
);

    reg [7:0] memory [0:32767];
    reg [7:0] mem_out;

    // Output/Tri-state
    assign data = (!csn && !oen && wen) ? mem_out : 8'bz;

    // Write
    always @(addr or data or csn or wen) begin
        if (!csn && !wen) begin
            memory[addr] = data;
        end
    end

    // Read
    always @(addr or csn or wen) begin
        if (!csn && wen) begin
            mem_out = memory[addr];
        end
    end

    /* Instantiation:
    ram_62256 new_instance (
        .addr(),
        .data(),

        .csn(),
        .oen(),
        .wen()
    );
    */
endmodule
