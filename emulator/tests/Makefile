test: test-138 test-161-basics test-161-chaining test-245 test-173 test-gp-register test-283 test-86b test-86p test-alu-addsub test-08b test-08p test-02b test-02p

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

test-86b: tb_86b.vvp
	@vvp $<

test-86p: tb_86p.vvp
	@vvp $<

test-08b: tb_08b.vvp
	@vvp $<

test-08p: tb_08p.vvp
	@vvp $<

test-02b: tb_02b.vvp
	@vvp $<

test-02p: tb_02p.vvp
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


TB86BSRC=../chips/xor_86b.v testhelpers.v tb_86b.v

tb_86b.vvp: $(TB86BSRC)
	iverilog $(TB86BSRC) -o $@

TB86PSRC=../chips/xor_86p.v testhelpers.v tb_86p.v

tb_86p.vvp: $(TB86PSRC)
	iverilog $(TB86PSRC) -o $@

TB08BSRC=../chips/and_08b.v testhelpers.v tb_08b.v

tb_08b.vvp: $(TB08BSRC)
	iverilog $(TB08BSRC) -o $@

TB08PSRC=../chips/and_08p.v testhelpers.v tb_08p.v

tb_08p.vvp: $(TB08PSRC)
	iverilog $(TB08PSRC) -o $@


TB02BSRC=../chips/nor_02b.v testhelpers.v tb_02b.v

tb_02b.vvp: $(TB02BSRC)
	iverilog $(TB02BSRC) -o $@

TB02PSRC=../chips/nor_02p.v testhelpers.v tb_02p.v

tb_02p.vvp: $(TB02PSRC)
	iverilog $(TB02PSRC) -o $@


TBGPREGSRC=../chips/dff_173.v ../chips/buffer_245.v ../cpu-modules/gp_register.v testhelpers.v tb_gp_register.v

tb_gp_register.vvp: $(TBGPREGSRC)
	iverilog $(TBGPREGSRC) -o $@

TBALUADDSUBSRC=../chips/buffer_245.v ../chips/adder_283.v ../chips/xor_86b.v ../chips/xor_86p.v ../chips/and_08p.v ../cpu-modules/alu_addsub.v testhelpers.v tb_alu_addsub.v

tb_alu_addsub.vvp: $(TBALUADDSUBSRC)
	iverilog $(TBALUADDSUBSRC) -o $@

clean:
	rm -f *.vvp
