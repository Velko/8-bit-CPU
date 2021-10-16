module buffer_125p (
    input a1,
    input oen1,
    output y1,

    input a2,
    input oen2,
    output y2,

    input a3,
    input oen3,
    output y3,

    input a4,
    input oen4,
    output y4);

    assign y1 = oen1 ? 1'bz : a1;
    assign y2 = oen2 ? 1'bz : a2;
    assign y3 = oen3 ? 1'bz : a3;
    assign y4 = oen4 ? 1'bz : a4;

endmodule

