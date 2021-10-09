test: test-138 test-161-chaining test-245 test-173 test-gp-register

test-138: tb_138.vvp
	vvp $<

test-161-chaining: tb_161_chaining.vvp
	vvp $<

test-245: tb_245.vvp
	vvp $<

test-173: tb_173.vvp
	vvp $<

test-gp-register: tb_gp_register.vvp
	vvp $<

TB138SRC=../chips/demux_138.v testhelpers.v tb_138.v

tb_138.vvp: $(TB138SRC)
	iverilog $(TB138SRC) -o $@


TB161CHAINSRC=../chips/counter_161.v testhelpers.v tb_161_chaining.v

tb_161_chaining.vvp: $(TB161CHAINSRC)
	iverilog $(TB161CHAINSRC) -o $@


TB245SRC=../chips/buffer_245.v testhelpers.v tb_245.v

tb_245.vvp: $(TB245SRC)
	iverilog $(TB245SRC) -o $@

TB173SRC=../chips/dff_173.v testhelpers.v tb_173.v

tb_173.vvp: $(TB173SRC)
	iverilog $(TB173SRC) -o $@

TBGPREGSRC=../chips/dff_173.v ../chips/buffer_245.v ../cpu-modules/gp_register.v testhelpers.v tb_gp_register.v

tb_gp_register.vvp: $(TBGPREGSRC)
	iverilog $(TBGPREGSRC) -o $@


clean:
	rm -f *.vvp
