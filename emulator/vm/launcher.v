module launcher;

    reg power_on;

    cpu processor(
        .power_on(power_on)
    );

    initial begin
        power_on <= 1;
        #1
        power_on <= 0;
    end

endmodule
