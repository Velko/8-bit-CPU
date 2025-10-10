module display_lcd(
    inout [7:0] io_bus,
    input enable,
    input rnw,
    input rs
);

    reg [159:0] out_fmt;
    reg [7:0] busy_val;

    initial begin
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
                $swrite(out_fmt, "#FOUT#16#\\n");
            end
            else begin
                $sformat(out_fmt, "#FOUT#16#%c", io_bus);
            end
            $hdb_send_str(out_fmt);
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

    assign io_bus = rnw && !rs && &enable ? busy_val : 8'bz;

endmodule
