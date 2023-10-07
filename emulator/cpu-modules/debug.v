module debug (
    inout [7:0] main_bus,
    inout [15:0] addr_bus,
    input brk,
    input hlt,
    input power_on,

    input [3:0] fout,
    input [7:0] iout,

    output reg ctrlen,
    output reg rst,
    output clk,
    inout iclk,

    inout [31:0] control_word
);
    reg [7:0] data;
    reg fdata;
    reg [15:0] addr;
    reg faddr;

    reg clk_l;
    reg iclk_l;
    reg [31:0] control_word_l;

    reg [7:0] cmd;
    reg [31:0] _discard;

    always @(negedge iclk or posedge power_on) begin
        if (brk || !hlt || power_on) begin
            if (brk) begin
                $serial_send_str("#BRK");
            end
            if (!hlt) begin
                $serial_send_str("#HLT");
            end

            ctrlen <= 1;
            #100; // give long enough for clock to disengage

            while (ctrlen) begin
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
                        $serial_get_arg(control_word_l);
                    end

                    "M": begin
                        // Set control word
                        $serial_get_arg(control_word_l);
                    end

                    "N", 8'hff: begin
                        // NOP, serial read timeout
                    end

                    "c": begin
                        // clk_pulse
                        clk_l <= 1;
                        #1
                        clk_l <= 0;
                    end

                    "C": begin
                        // iclk_pulse
                        iclk_l <= 1;
                        #1
                        iclk_l <= 0;
                    end

                    "T": begin
                        // clock_tick
                        clk_l <= 1;
                        #1
                        clk_l <= 0;
                        #1
                        iclk_l <= 1;
                        #1
                        iclk_l <= 0;
                    end

                    "r": begin
                        // read current_opcode
                        $serial_get_arg(_discard); // client sends control word for IRFetch, discard it
                        $serial_send_int(iout);
                    end

                    "R": begin
                        // run_program
                        ctrlen <= 0;
                    end

                    "Z": begin
                        rst <= 1;
                        #1;
                        clk_l <= 1;
                        #1;
                        clk_l <= 0;
                        #1;
                        iclk_l <= 1;
                        #1;
                        iclk_l <= 0;
                        rst <= 0;
                    end

                    "Q": begin
                        $display("\nRemote shutdown requested.");
                        $finish;
                    end

                    default:
                        $display("Unknown command %c", cmd);
                endcase
                #1;
            end
        end
    end

    assign main_bus = fdata ? data : 8'bz;
    assign addr_bus = faddr ? addr : 16'bz;
    assign clk = ctrlen ? clk_l : 1'bZ;
    assign iclk = ctrlen ? iclk_l : 1'bZ;
    assign control_word = ctrlen ? control_word_l : 32'bZ;

endmodule