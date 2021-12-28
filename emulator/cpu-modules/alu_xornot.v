module alu_xornot (
    input outn,
    input fn_not,
    input [7:0] arg_l,
    input [7:0] arg_r,
    output [7:0] bus);

    wire [7:0] out_v;

    xor_86b xor_l(.a(arg_l[3:0]), .b(or_l.y), .y(out_v[3:0]));
    xor_86b xor_h(.a(arg_l[7:4]), .b(or_h.y), .y(out_v[7:4]));

    or_32b or_l(.a(arg_r[3:0]), .b({fn_not, fn_not, fn_not, fn_not}));
    or_32b or_h(.a(arg_r[7:4]), .b({fn_not, fn_not, fn_not, fn_not}));

    buffer_245 bus_buf(.oen(outn), .dir(1'b1), .a(out_v), .b(bus));

endmodule