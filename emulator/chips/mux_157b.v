module mux_157b (
    input [3:0] a,
    input [3:0] b,
    output[3:0] y,
    
    input en,
    input sel);

    assign y = en ? 4'h0 : ( sel ? b : a);

    /* Instantiation:
    mux_157b new_instance (
        .a(),
        .b(),
        .y(),
        .en(),
        .sel()
    );
    */
endmodule
