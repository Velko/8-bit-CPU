module cmd_handler;

    reg [7:0] data;
    reg fdata;
    wire [7:0] main_bus;

    reg [15:0] addr;
    reg faddr;
    wire [15:0] addr_bus;

    wire [3:0] fout;
    wire [7:0] iout;

    reg rst;
    reg clk;
    reg iclk;

    reg [31:0] control_word;
    wire [31:0] wctrl_word;
    reg ctrlen;

    cpu processor(.main_bus(main_bus), .addr_bus(addr_bus), .rst(rst), .clk(clk), .iclk(iclk), .control_word(wctrl_word), .fout(fout), .iout(iout), .ctrlen(ctrlen));

    reg [7:0] cmd;

    reg [31:0] _discard;

    initial begin
        clk <= 0;
        iclk <= 0;
        rst <= 1;
        ctrlen <= 1;
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
                    // Write address
                    $serial_get_arg(addr);
                    faddr <= 1;
                end

                "a": begin
                    // Read address
                    $serial_send_int(addr_bus);
                end

                "B": begin
                    // Write bus
                    $serial_get_arg(data);
                    fdata <= 1;
                end

                "b": begin
                    // Read bus
                    $serial_send_int(main_bus);
                end

                "s": begin
                    // Flags
                    $serial_send_int(fout);
                end

                "f": begin
                    // Release buses
                    faddr <= 0;
                    fdata <= 0;
                end

                "O": begin
                    // Off
                    faddr <= 0;
                    fdata <= 0;
                    $serial_get_arg(control_word);
                end

                "M": begin
                    // Set control word
                    $serial_get_arg(control_word);
                end

                "N", 8'hff: begin
                    // NOP, serial read timeout
                end

                "c": begin
                    // clk_pulse
                    clk <= 1;
                    #1
                    clk <= 0;
                end

                "C": begin
                    // iclk_pulse
                    iclk <= 1;
                    #1
                    iclk <= 0;
                end

                "T": begin
                    // clock_tick
                    clk <= 1;
                    #1
                    clk <= 0;
                    #1
                    iclk <= 1;
                    #1
                    iclk <= 0;
                end

                "r": begin
                    // read current_opcode
                    $serial_get_arg(_discard); // client sends control word for IRFetch, discard it
                    $serial_send_int(iout);
                end

                "R": begin
                    // run_program
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
    assign wctrl_word = ctrlen? control_word : 32'bz;

endmodule