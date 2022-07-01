module display_char(
    inout [7:0] main_bus,
    output reg [159:0] out_fmt,
    input out_rst,
    input clk,
    input load_val
);
    initial begin
        out_fmt <= 160'bx;
    end

    always @(posedge clk) begin
        if (load_val) begin
            if (main_bus == "\n") begin
                $swrite(out_fmt, "#FOUT#\\n");
            end
            else begin
                $sformat(out_fmt, "#FOUT#%c", main_bus);
            end
        end
    end

    always @(posedge out_rst) begin
        out_fmt <= 160'bx;
    end

endmodule
