module tb_control_logic;

    reg [3:0] flags;
    reg [7:0] opcode;
    reg rstn;

    wire [31:0] control_word;
    reg ctrlen;

    reg iclk;

    reg step_reset;
    reg step_ext;

    control_logic ctrl(.opcode(opcode), .flags(flags), .rstn(rstn), .iclk(iclk), .control_word(control_word), .ctrlen(ctrlen),
        .step_reset(step_reset),
        .step_ext(step_ext)
    );

    initial begin
        $display("Control logic...");
        iclk <= 0;
        ctrlen <= 0;
        rstn <= 0;
        step_reset <= 1;
        #1
        rstn <= 1;

        flags <= 0;
        opcode <= 1;
        #1
        // fetch
        `assert(control_word, 32'h3af834c3);

        // LDI A, step 1, step reset
        `tick(iclk, 2);
        `assert(control_word, 32'h3af83043);

        opcode <= 8'h17;
        #1 // ADC A, A step 1, default, step reset
        `assert(control_word, 32'h3be03002);

        flags <= 4'h4;
        #1 // ADC A, A step 1, alt on C, step reset
        `assert(control_word, 32'h3be07002);
    end


endmodule
