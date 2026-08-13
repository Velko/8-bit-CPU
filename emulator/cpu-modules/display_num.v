module display_num(
    input [7:0] main_bus,
    input clk,
    input load_val,
    input [1:0] mode
);

    wire signed [7:0] signed_bus;
    reg [255:0] out_fmt;

    always @(posedge clk) begin
        if (load_val) begin
            case (mode)
            0: $sformat(out_fmt, "#OUT#0# %d\\n", main_bus);
            1: $sformat(out_fmt, "#OUT#0#%d\\n", signed_bus);
            2: $sformat(out_fmt, "#OUT#0#h %h\\n", main_bus);
            3: $sformat(out_fmt, "#OUT#0#o%o\\n", main_bus);
            default: $swrite(out_fmt, "#OUT#0#x\\n");
            endcase
            $hdb_send_str(0, out_fmt);
        end

    end

    assign signed_bus = main_bus;

endmodule
