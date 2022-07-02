module display_lcd(
    inout [7:0] io_bus,
    output reg [159:0] out_fmt,
    input out_rst,
    input enable,
    input rnw,
    input rs
);

    reg [7:0] busy_val;

    initial begin
        out_fmt <= 160'bx;
        busy_val <= 8'h80;
    end

    /* Very rough approximation on Hitachi HD44780 LCD controller interface:
       Writing data and commands sets busy flag, it won't accept further commands/data
       until status is read at least once.
     */
    always @(posedge enable) begin

        //$display("R/~W: %b", rnw);
        //$display("RS: %b", rs);

        /* Data write */
        if (!rnw && rs && busy_val == 8'h00) begin
            if (io_bus == "\n") begin
                $swrite(out_fmt, "#FOUT#\\n");
            end
            else begin
                $sformat(out_fmt, "#FOUT#%c", io_bus);
            end
            busy_val <= 8'h80;
        end

        /* Command */
        if (!rnw && !rs && busy_val == 8'h00) begin
            /* Currently ignore the command, just set the busy flag */
            busy_val <= 8'h80;
        end
    end

    always @(negedge enable) begin
        /* Release busy bit after read */
        if (rnw && !rs) begin
            busy_val <= 8'h00;
        end
    end

    always @(posedge out_rst) begin
        out_fmt <= 160'bx;
    end

    assign io_bus = rnw && !rs ? busy_val : 8'bz;

endmodule
