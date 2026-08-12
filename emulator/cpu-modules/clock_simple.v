module clock (
    input ctrlen,
    input brk,
    input hlt,

    output clk,
    output iclk
);

    reg clk_l;
    reg iclk_l;
    reg ctrlen_l;

    wire brk_r;
    wire hlt_r;

    dff_74 state (
        .rd1n(1'b1),
        .sd1n(1'b1),
        .d1(brk),
        .cp1(!iclk), //TODO: inverter

        .q1(brk_r),
        //.q1n(),

        .rd2n(1'b1),
        .sd2n(1'b1),
        .d2(hlt),
        .cp2(!iclk),

        .q2(hlt_r)
        //.q2n()
    );

    always @(negedge iclk_l) begin
        ctrlen_l <= ctrlen;
    end

    always @(posedge brk_r) begin
        $hdb_send_str(0, "#BRK");
    end

    always @(negedge hlt_r) begin
        $hdb_send_str(0, "#HLT");
    end

    initial begin
        ctrlen_l <= 1;
        #1;

        forever begin
            clk_l <= 0;
            iclk_l <= 0;
            #10

            clk_l <= 1;
            #10

            clk_l <= 0;
            #10

            iclk_l <= 1;
            #10;

        end
    end


    assign clk = !ctrlen_l ? clk_l : 1'bZ;
    assign iclk = !ctrlen_l ? iclk_l : 1'bZ;


endmodule
