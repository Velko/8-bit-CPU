module alu_addsub (
    input outn,
    input sub,
    input [7:0] arg_l,
    input [7:0] arg_r,
    input cin,
    output [7:0] bus,
    output cout,
    output vout);

    xor_86 xor_flags(.a({xor_h.y[3], arg_l[7], cin, add_h.cout}), .b({add_h.s[3], add_h.s[3], sub, sub}));
    and_08 and_v(.a({3'bx, xor_flags.y[2]}), .b({3'bx, xor_flags.y[3]}));

    xor_86 xor_l(.a(arg_r[3:0]), .b({sub, sub, sub, sub}));
    adder_283 add_l(.a(arg_l[3:0]), .b(xor_l.y), .cin(xor_flags.y[1]));

    xor_86 xor_h(.a(arg_r[7:4]), .b({sub, sub, sub, sub}));
    adder_283 add_h(.a(arg_l[7:4]), .b(xor_h.y), .cin(add_l.cout));

    buffer_245 bus_buf(.oen(outn), .dir(1'b1), .a({add_h.s, add_l.s}), .b(bus));

    assign cout = xor_flags.y[0];
    assign vout = and_v.y[0];

endmodule
