test: test-138 test-161-basics test-161-chaining test-245 test-173 test-gp-register test-283 test-86 test-alu-addsub test-08

test-138: tb_138.vvp
	@vvp $<

test-161-basics: tb_161_basics.vvp
	@vvp $<

test-161-chaining: tb_161_chaining.vvp
	@vvp $<

test-245: tb_245.vvp
	@vvp $<

test-173: tb_173.vvp
	@vvp $<

test-283: tb_283.vvp
	@vvp $<

test-86: tb_86.vvp
	@vvp $<

test-08: tb_08.vvp
	@vvp $<

test-gp-register: tb_gp_register.vvp
	@vvp $<

test-alu-addsub: tb_alu_addsub.vvp
	@vvp $<


TB138SRC=../chips/demux_138.v testhelpers.v tb_138.v

tb_138.vvp: $(TB138SRC)
	iverilog $(TB138SRC) -o $@


TB161BASICSRC=../chips/counter_161.v testhelpers.v tb_161_basics.v

tb_161_basics.vvp: $(TB161BASICSRC)
	iverilog $(TB161BASICSRC) -o $@


TB161CHAINSRC=../chips/counter_161.v testhelpers.v tb_161_chaining.v

tb_161_chaining.vvp: $(TB161CHAINSRC)
	iverilog $(TB161CHAINSRC) -o $@


TB245SRC=../chips/buffer_245.v testhelpers.v tb_245.v

tb_245.vvp: $(TB245SRC)
	iverilog $(TB245SRC) -o $@

TB173SRC=../chips/dff_173.v testhelpers.v tb_173.v

tb_173.vvp: $(TB173SRC)
	iverilog $(TB173SRC) -o $@

TB283SRC=../chips/adder_283.v testhelpers.v tb_283.v

tb_283.vvp: $(TB283SRC)
	iverilog $(TB283SRC) -o $@


TB86SRC=../chips/xor_86.v testhelpers.v tb_86.v

tb_86.vvp: $(TB86SRC)
	iverilog $(TB86SRC) -o $@

TB08SRC=../chips/and_08.v testhelpers.v tb_08.v

tb_08.vvp: $(TB08SRC)
	iverilog $(TB08SRC) -o $@


TBGPREGSRC=../chips/dff_173.v ../chips/buffer_245.v ../cpu-modules/gp_register.v testhelpers.v tb_gp_register.v

tb_gp_register.vvp: $(TBGPREGSRC)
	iverilog $(TBGPREGSRC) -o $@

TBALUADDSUBSRC=../chips/buffer_245.v ../chips/adder_283.v ../chips/xor_86.v ../cpu-modules/alu_addsub.v testhelpers.v tb_alu_addsub.v

tb_alu_addsub.vvp: $(TBALUADDSUBSRC)
	iverilog $(TBALUADDSUBSRC) -o $@

clean:
	rm -f *.vvp
