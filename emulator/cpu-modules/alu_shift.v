module alu_shift (
    input outn,
    input [7:0] arg_l,
    input cin,
    output [7:0] bus,
    output cout);

    wire [7:0] out_v = {cin, arg_l[7:1]};

    buffer_245 bus_buf(
        .oen(outn),
        .dir(1'b1),
        .a(out_v),
        .b(bus));

    buffer_125p flags_buf(
        .a1(arg_l[0]),
        .y1(cout),
        .oen1(outn),

        .a2(1'b0),
        .a3(1'b0),
        .a4(1'b0),
        .oen2(1'b1),
        .oen3(1'b1),
        .oen4(1'b1));

endmodule
