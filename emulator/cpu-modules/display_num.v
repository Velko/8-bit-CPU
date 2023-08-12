module display_num(
    input [7:0] main_bus,
    output reg [255:0] out_fmt,
    input out_rst,
    input clk,
    input load_val,
    input load_mode,
    input reset
);

    wire signed [7:0] signed_bus;
    reg [7:0] ifmt_mode;

    initial begin
        out_fmt <= 256'bx;
    end

    always @(posedge clk) begin
        if (load_val) begin
            case (ifmt_mode)
            0: $sformat(out_fmt, "#FOUT#\033[1;31m %d\033[0m\\n", main_bus);
            1: $sformat(out_fmt, "#FOUT#\033[1;31m%d\033[0m\\n", signed_bus);
            2: $sformat(out_fmt, "#FOUT#\033[1;31mh %h\033[0m\\n", main_bus);
            3: $sformat(out_fmt, "#FOUT#\033[1;31mo%o\033[0m\\n", main_bus);
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

    always @(posedge out_rst or posedge reset) begin
        out_fmt <= 256'bx;
    end

    assign signed_bus = main_bus;

endmodule
