module clock (
    input ctrlen,

    output clk,
    output iclk
);

    reg clk_l;
    reg iclk_l;
    reg ctrlen_l;

    always @(negedge iclk_l) begin
        ctrlen_l <= ctrlen;
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
