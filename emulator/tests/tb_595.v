module tb_595;

    reg ds;
    reg oen;
    reg cp_st;
    reg cp_sh;
    reg mrn;

    wire [15:0] sh_output;

    shift_595 shreg0 (
        .ds(ds),
        .oen(oen),
        .cp_st(cp_st),
        .cp_sh(cp_sh),
        .mrn(mrn),
        .q(sh_output[7:0])
    );

    shift_595 shreg1 (
        .ds(shreg0.q7p),
        .oen(oen),
        .cp_st(cp_st),
        .cp_sh(cp_sh),
        .mrn(mrn),
        .q(sh_output[15:8])
    );

    initial begin
        $display("74xx595 SIPO shift register...");
        ds <= 0;
        oen <= 1;
        cp_st <= 0;
        cp_sh <= 0;

        #1
        `assert(sh_output, 16'bZ);

        oen <= 0;
        #1
        `assert(sh_output, 16'bX);

        mrn <= 0;
        #1
        `assert(sh_output, 16'b0);

        mrn <= 1;
        ds <= 1;
        `tick(cp_sh, 2);
        `assert(sh_output, 16'b0);
        `tick(cp_st, 2);
        `assert(sh_output, 16'b1);

        ds <= 0;
        `tick(cp_sh, 10);
        `assert(sh_output, 16'b1);
        `tick(cp_st, 2);
        `assert(sh_output, 16'b10_0000);

        `tick(cp_sh, 10);
        `tick(cp_st, 2);
        `assert(sh_output, 16'b100_0000_0000);
    end

endmodule