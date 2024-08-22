`define assert(signal, value) if (signal !== value) begin $display("ASSERTION FAILED in %m: signal != value, was %b", signal); $fatal; end
`define toggle(signal, times ) repeat (times) begin signal <= ~signal; #5; end
`define tick(signal) `toggle(signal, 2)
`define pulse(signal, times) `toggle(signal, times * 2)