module tb_245;

    reg [7:0] data;
    wire [7:0] win;
    reg oen;
    reg dir;

    buffer_245 atob(.a(win), .oen(oen), .dir(dir));
    buffer_245 btoa(.b(win), .oen(oen), .dir(!dir));

    assign win = data;

    initial begin
        $display("74xx245 buffer...");

        data <= 8'ha5;
        oen <= 1;
        dir <= 1;

        #1
        `assert(atob.b, 8'bZ);
        `assert(btoa.a, 8'bZ);

        oen <= 0;
        #1
        `assert(atob.b, 8'ha5);
        `assert(btoa.a, 8'ha5);

        dir <= 0; // an invalid condition
        #1
        `assert(atob.b, 8'bZ);
        `assert(btoa.a, 8'bZ);
    end

endmodule