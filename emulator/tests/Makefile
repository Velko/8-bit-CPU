test: test-138 test-161-chaining

test-138: tb_138.vvp
	vvp $<

test-161-chaining: tb_161_chaining.vvp
	vvp $<

TB138SRC=../chips/demux_138.v testhelpers.v tb_138.v

tb_138.vvp: $(TB138SRC)
	iverilog $(TB138SRC) -o $@


TB161CHAINSRC=../chips/counter_161.v testhelpers.v tb_161_chaining.v

tb_161_chaining.vvp: $(TB161CHAINSRC)
	iverilog $(TB161CHAINSRC) -o $@


clean:
	rm -f *.vvp
