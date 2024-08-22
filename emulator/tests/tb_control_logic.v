module tb_control_logic;

    reg [3:0] flags;
    reg [7:0] opcode;
    reg rstn;

    wire [31:0] control_word;
    reg ctrlen;

    reg clk;
    reg iclk;

    reg step_resetn;
    reg step_extn;

    control_logic ctrl(.opcode(opcode), .flags(flags), .rstn(rstn), .clk(clk), .iclk(iclk), .control_word(control_word), .ctrlen(ctrlen),
        .step_resetn(step_resetn),
        .step_extn(step_extn)
    );

    initial begin
        $display("Control logic...");
        //$finish;
        clk <= 0;
        iclk <= 0;
        ctrlen <= 0;
        rstn <= 0;
        step_resetn <= 1;
        step_extn <= 1;
        #1
        rstn <= 1;

        flags <= 0;
        opcode <= 1;
        #1
        // fetch
        `assert(control_word, 32'h07bd5889);

        // LDI A, step 1, step reset
        `tick(clk);
        `tick(iclk);
        `assert(control_word, 32'h06bd5809);

        opcode <= 8'h17;
        #1 // ADC A, A step 1, default, step reset
        `assert(control_word, 32'h06ff0005);

        flags <= 4'h4;
        #1 // ADC A, A step 1, alt on C, step reset
        `assert(control_word, 32'h06ff8005);

        // ext prefix
        flags <= 0;
        opcode <= 8'hee;
        #1 // XPREFIX step1, no step reset, step_ext
        `assert(control_word, 32'h05bd5889);

        // load ext
        step_extn <= 0;
        opcode <= 8'h0d;
        #1
        `tick(clk);
        `tick(iclk);
        // DUMMY_EXT step1, no step reset, no step ext
        `assert(control_word, 32'h07ff58ff);

        // ext. bit should "stick"
        step_extn <= 1;
        #1
        `tick(clk);
        `tick(iclk);
        // DUMMY_EXT step2, no step reset, no step ext
        `assert(control_word, 32'h07ff58ff);

        `tick(clk);
        `tick(iclk);
        // DUMMY_EXT step3, step reset, no step ext
        `assert(control_word, 32'h06bd5809);

        step_resetn <= 0;
        opcode <= 8'h01;
        #1
        `tick(clk);
        `tick(iclk);
        // fetch again
        `assert(control_word, 32'h07bd5889);

        step_resetn <= 1;
        #1
        // LDI A, step 1, step reset (again)
        `tick(clk);
        `tick(iclk);
        `assert(control_word, 32'h06bd5809);

    end


endmodule
