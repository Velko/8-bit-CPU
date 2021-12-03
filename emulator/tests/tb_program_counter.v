module tb_program_counter;

    reg outn;
    reg loadn;
    reg count;

    reg clk;
    reg iclk;
    reg reset;
    wire resetn;

    wire [15:0] abus;
    reg [7:0] addr;
    reg wbus;

    program_counter pc (.outn(outn), .loadn(loadn), .count(count), .clk(clk), .iclk(iclk), .reset(reset), .resetn(resetn));

initial begin
        $display("Program counter...");

        outn <= 1;
        loadn <= 1;
        count <= 0;
        clk <= 0;
        iclk <= 0;
        reset <= 0;
        wbus <= 0;


end

    assign resetn = !reset;
    assign abus = wbus ? addr : 16'bZ;

endmodule