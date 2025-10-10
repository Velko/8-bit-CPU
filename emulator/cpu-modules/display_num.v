module display_num(
    input [7:0] main_bus,
    input clk,
    input load_val,
    input load_mode,
    input reset
);

    wire signed [7:0] signed_bus;
    reg [255:0] out_fmt;
    reg [7:0] ifmt_mode;

    always @(posedge clk) begin
        if (load_val) begin
            case (ifmt_mode)
            0: $sformat(out_fmt, "#FOUT#0# %d\\n", main_bus);
            1: $sformat(out_fmt, "#FOUT#0#%d\\n", signed_bus);
            2: $sformat(out_fmt, "#FOUT#0#h %h\\n", main_bus);
            3: $sformat(out_fmt, "#FOUT#0#o%o\\n", main_bus);
            default: $swrite(out_fmt, "#FOUT#0#x\\n");
            endcase
            $hdb_send_str(out_fmt);
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
