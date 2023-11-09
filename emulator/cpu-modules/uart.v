module uart(
    inout [7:0] io_bus,
    input sel_data,
    input sel_status,
    input rnw,
    input clk
);

    reg [7:0] in_data;
    reg [7:0] status;

    initial begin
        status <= 8'b0;
    end

    always @(posedge clk) begin
        if (sel_data && !rnw) begin
            $serial_send_char(io_bus);
        end
    end

    always @(negedge clk) begin
        if (sel_data && rnw) begin
            $serial_discard_char();
        end
    end

    always @(posedge sel_status or posedge rnw) begin
        if (sel_status && rnw) begin
            $serial_check_input(status);
        end
    end

    always @(posedge sel_data or posedge rnw) begin
        if (sel_data && rnw) begin
            $serial_peek_char(in_data);
        end
    end

    wire [7:0] read_outp = sel_data ? in_data : status;
    assign io_bus = rnw ? read_outp : 8'bZ;

endmodule
