module alu_swap (
    input outn,
    input [7:0] arg_l,
    output [7:0] bus);

    wire [7:0] out_v = {arg_l[3:0], arg_l[7:4]};

    buffer_245 bus_buf(
        .oen(outn),
        .dir(1'b1),
        .a(out_v),
        .b(bus));

endmodule
