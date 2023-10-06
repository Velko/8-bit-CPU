module tx_register (
    input aoutn,
    input aloadn,
    input moutn,
    input mloadn,

    input clk,
    input iclk,
    input reset,

    inout [7:0] mbus,
    inout [7:0] abus);


    wire [7:0] out_v;
    wire [7:0] sel_v;

    and_08p load_en(.a1(aloadn), .b1(mloadn), .a2(1'b0), .b2(1'b0), .a3(1'b0), .b3(1'b0), .a4(1'b0), .b4(1'b0));

    mux_157b sel_in_l(.a(mbus[3:0]), .b(abus[3:0]), .en(1'b0), .sel(mloadn), .y(sel_v[3:0]));
    mux_157b sel_in_h(.a(mbus[7:4]), .b(abus[7:4]), .en(1'b0), .sel(mloadn), .y(sel_v[7:4]));

    dff_377 prim_reg(.cp(clk), .en(load_en.y1), .d(sel_v), .q(out_v));

    buffer_245 mbus_buf(.oen(moutn), .dir(1'b1), .a(out_v), .b(mbus));
    buffer_245 abus_buf(.oen(aoutn), .dir(1'b1), .a(out_v), .b(abus));

    always @(posedge clk) begin
        if (mloadn == 1'b0 && ^mbus === 1'bX)
            $error("Attempting to load %b", mbus);

        if (aloadn == 1'b0 && ^abus === 1'bX)
            $error("Attempting to load %b", abus);
    end

endmodule
