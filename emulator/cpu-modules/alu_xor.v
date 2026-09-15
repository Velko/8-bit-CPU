module alu_xor (
    input outn,
    input [7:0] arg_l,
    input [7:0] arg_r,
    output [7:0] bus);

    wire [7:0] out_v;

    xor_86b xor_l(.a(arg_l[3:0]), .b(arg_r[3:0]), .y(out_v[3:0]));
    xor_86b xor_h(.a(arg_l[7:4]), .b(arg_r[7:4]), .y(out_v[7:4]));

    buffer_245 bus_buf(.oen(outn), .dir(1'b1), .a(out_v), .b(bus));

endmodule
