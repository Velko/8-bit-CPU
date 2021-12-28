module cmd_handler;

    reg [7:0] data;
    reg fdata;
    wire [7:0] main_bus;

    reg [15:0] addr;
    reg faddr;
    wire [15:0] addr_bus;

    wire [3:0] fout;

    reg rst;
    reg clk;
    reg iclk;

    reg [31:0] control_word;

    cpu processor(.main_bus(main_bus), .addr_bus(addr_bus), .rst(rst), .clk(clk), .iclk(iclk), .control_word(control_word), .fout(fout));

    reg [7:0] cmd;

    initial begin
        clk <= 0;
        iclk <= 0;
        rst <= 1;
        $set_default_cw(control_word);

        #1
        rst <= 0;


        forever begin
            $serial_get_cmd(cmd);

            case (cmd)
                "I": begin
                    // Identify
                    $serial_send_str("VerilogVM");
                end

                "A": begin
                    $serial_get_arg(addr);
                    faddr <= 1;
                    $display("Write address %h", addr);
                end

                "a": begin
                    $display("Read address");
                    $serial_send_int(addr_bus);
                end

                "B": begin
                    $serial_get_arg(data);
                    fdata <= 1;
                    $display("Write bus %h", data);
                end

                "b": begin
                    $display("Read bus");
                    $serial_send_int(main_bus);
                end

                "s": begin
                    $display("Flags");
                    $serial_send_int(fout);
                end

                "f": begin
                    $display("Release buses");
                    faddr <= 0;
                    fdata <= 0;
                end

                "O": begin
                    faddr <= 0;
                    fdata <= 0;
                    $serial_get_arg(control_word);
                    $display("Off");
                end

                "M": begin
                    $serial_get_arg(control_word);
                    $display("Set control word");
                end

                "N", 8'hff: begin
                    // NOP, serial read timeout
                end

                "c": begin
                    $display("clk_pulse");
                    clk <= 1;
                    #1
                    clk <= 0;
                end

                "C": begin
                    $display("iclk_pulse");
                    iclk <= 1;
                    #1
                    iclk <= 0;
                end

                "T": begin
                    $display("clock_tick");
                    clk <= 1;
                    #1
                    clk <= 0;
                    #1
                    iclk <= 1;
                    #1
                    iclk <= 0;
                end

                "r": begin
                    $display("read current_opcode");
                    $serial_send_int(0);
                end

                "R": begin
                    $display("run_program");
                    $serial_send_str("#BRK"); // return control immediately
                end

                "Q":
                    $finish;

                default:
                    $display("Unknown command %c", cmd);
            endcase
            #1;
        end
    end

    assign main_bus = fdata ? data : 8'bz;
    assign addr_bus = faddr ? addr : 16'bz;

endmodule