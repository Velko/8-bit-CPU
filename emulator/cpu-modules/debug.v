`include "cword.vinc"

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
                $hdb_send_str("#BRK");
            end
            if (!hlt) begin
                $hdb_send_str("#HLT");
            end

            ctrlen <= 1;
            #100; // give long enough for clock to disengage

            while (ctrlen) begin
                $hdb_get_char(cmd);
                case (cmd)
                    "I": begin
                        // Identify
                        $hdb_send_str("VerilogVM");
                    end

                    "A": begin
                        // Write address
                        $hdb_get_int(addr);
                        faddr <= 1;
                    end

                    "a": begin
                        // Read address
                        $hdb_send_int(addr_bus);
                    end

                    "B": begin
                        // Write bus
                        $hdb_get_int(data);
                        fdata <= 1;
                    end

                    "b": begin
                        // Read bus
                        $hdb_send_int(main_bus);
                    end

                    "s": begin
                        // Flags
                        $hdb_send_int(fout);
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
                        $hdb_get_int(control_word_l);
                    end

                    "M": begin
                        // Set control word
                        $hdb_get_int(control_word_l);
                    end

                    "N", 8'hff: begin
                        // NOP, read timeout
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
                        $hdb_get_int(_discard); // client sends control word for IRFetch, discard it
                        $hdb_send_int(iout);
                    end

                    "R": begin
                        // run_program
                        ctrlen <= 0;
                    end

                    "Z": begin
                        rst <= 1;
                        /* Reset requires clock pulse to propogate because not all parts have asynchronouse
                           reset capabilities.

                           Another issue is that CPU may repeat the last operation. Normally we should not
                           case, except when it is an I/O operation.

                           TODO: handle it here or in I/O controller?? Former prevents similar "head-scratching"
                              moments in the future. Latter solves the issue just in misbehaving module.
                         */
                        control_word_l <= `DEFAULT_CW;
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