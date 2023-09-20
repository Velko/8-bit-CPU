module display_char(
    inout [7:0] main_bus,
    input clk,
    input load_val
);

    reg [159:0] out_fmt;

    always @(posedge clk) begin
        if (load_val) begin
            if (main_bus == "\n") begin
                $swrite(out_fmt, "#FOUT#\\n");
            end
            else begin
                $sformat(out_fmt, "#FOUT#%c", main_bus);
            end
            $serial_send_str(out_fmt);
        end
    end

endmodule
