module display_num(
    input [7:0] main_bus,
    output reg [159:0] out_fmt,
    input clk,
    input load_val,
    input load_mode,
    input reset
);

    wire signed [7:0] signed_bus;
    reg [7:0] ifmt_mode;

    initial begin
        out_fmt <= 160'bx;
    end

    always @(posedge clk) begin
        if (load_val) begin
            case (ifmt_mode)
            0: $sformat(out_fmt, "#FOUT# %d\\n", main_bus);
            1: $sformat(out_fmt, "#FOUT#%d\\n", signed_bus);
            2: $sformat(out_fmt, "#FOUT#h %h\\n", main_bus);
            3: $sformat(out_fmt, "#FOUT#o%o\\n", main_bus);
            default: $swrite(out_fmt, "#FOUT#x\\n");
            endcase
        end

        if (load_mode) begin
            ifmt_mode <= main_bus;
        end
    end

    always @(reset) begin
        if (reset == 1'b1) begin
            ifmt_mode <= 0;
        end
    end

    assign signed_bus = main_bus;

endmodule
